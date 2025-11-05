//
//  NetworkManager.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 20/10/25.
//  Updated on 05/11/25 - Optimized with interceptors, retry logic, and token refresh
//

import Foundation
import Combine

class NetworkManager: NetworkManagerProtocol, TokenRefreshable {
    static let shared = NetworkManager()

    private let session: URLSession
    private let secureStorage = SecureStorage.shared
    private var interceptors: [RequestInterceptor] = []
    private var isRefreshingToken = false
    private var tokenRefreshTask: Task<(String, String?), Error>?

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APIConfig.requestTimeout
        config.timeoutIntervalForResource = APIConfig.resourceTimeout
        session = URLSession(configuration: config)

        // Setup default interceptors
        setupDefaultInterceptors()
    }

    private func setupDefaultInterceptors() {
        // Order matters: Auth -> Retry -> Logging
        interceptors = [
            AuthInterceptor(),
            DefaultRequestInterceptor(tokenRefreshable: self),
            LoggingInterceptor()
        ]
    }

    // MARK: - Public API to add custom interceptors
    func addInterceptor(_ interceptor: RequestInterceptor) {
        interceptors.append(interceptor)
    }

    func removeAllInterceptors() {
        interceptors.removeAll()
        setupDefaultInterceptors()
    }

    // MARK: - Token Management

    /// Set authentication tokens
    func setTokens(jwt: String, refresh: String?) {
        _ = secureStorage.save(jwt, forKey: StorageKeys.Auth.jwtToken)

        if let refresh = refresh {
            _ = secureStorage.save(refresh, forKey: StorageKeys.Auth.refreshToken)
        }

        AppLogger.s("Auth tokens saved securely")
    }

    /// Clear all authentication tokens
    func clearTokens() {
        secureStorage.delete(forKey: StorageKeys.Auth.jwtToken)
        secureStorage.delete(forKey: StorageKeys.Auth.refreshToken)
        tokenRefreshTask?.cancel()
        tokenRefreshTask = nil
        isRefreshingToken = false

        AppLogger.i("Auth tokens cleared")
    }

    /// Check if valid token exists
    func hasValidToken() -> Bool {
        return secureStorage.exists(forKey: StorageKeys.Auth.jwtToken)
    }

    /// Get JWT token
    private func getJWTToken() -> String? {
        return secureStorage.loadString(forKey: StorageKeys.Auth.jwtToken)
    }

    /// Get refresh token
    private func getRefreshToken() -> String? {
        return secureStorage.loadString(forKey: StorageKeys.Auth.refreshToken)
    }

    // MARK: - TokenRefreshable

    /// Refresh access token using refresh token
    func refreshToken() async throws -> (accessToken: String, refreshToken: String?) {
        // If already refreshing, wait for that task to complete
        if let existingTask = tokenRefreshTask {
            return try await existingTask.value
        }

        // Create new refresh task
        let task = Task<(String, String?), Error> { () -> (String, String?) in
            guard let refreshToken = self.getRefreshToken() else {
                throw APIError.tokenRefreshFailed
            }

            AppLogger.i("Refreshing access token...")

            // Create refresh token request
            let endpoint = RefreshTokenRequest(refreshToken: refreshToken)
            let response: ApiResponse<AuthData> = try await self.performRequest(
                endpoint: endpoint,
                retryCount: 0,
                skipTokenRefresh: true // Important: avoid infinite loop
            )

            guard let authData = response.data else {
                throw APIError.noData
            }

            // Save new tokens
            self.setTokens(jwt: authData.accessToken, refresh: authData.refreshToken)

            AppLogger.s("Token refreshed successfully")

            return (authData.accessToken, authData.refreshToken)
        }

        tokenRefreshTask = task

        defer {
            tokenRefreshTask = nil
            isRefreshingToken = false
        }

        isRefreshingToken = true

        do {
            return try await task.value
        } catch {
            AppLogger.e("Token refresh failed: \(error.localizedDescription)")
            throw APIError.tokenRefreshFailed
        }
    }

    // MARK: - Private Helpers

    /// Map URLError to APIError
    private func mapError(_ error: Error) -> APIError {
        if let apiError = error as? APIError {
            return apiError
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noInternetConnection
            case .timedOut:
                return .timeout
            case .cancelled:
                return .requestCancelled
            default:
                return .networkError(urlError)
            }
        }

        if error is DecodingError {
            return .decodingError(error)
        }

        return .networkError(error)
    }

    /// Map HTTP status code to APIError
    private func mapStatusCodeToError(_ statusCode: Int, message: String?) -> APIError {
        switch statusCode {
        case 400:
            return .badRequest(message: message)
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 429:
            // Try to extract retry-after header if available
            return .tooManyRequests(retryAfter: nil)
        case 500:
            return .internalServerError
        case 503:
            return .serviceUnavailable
        default:
            return .serverError(statusCode: statusCode, message: message)
        }
    }

    // MARK: - Core Request Method (with retry and interceptor support)

    /// Base request method with retry logic and interceptor chain
    private func performRequest<T: Codable>(
        endpoint: any APIEndpoint,
        retryCount: Int = 0,
        skipTokenRefresh: Bool = false
    ) async throws -> ApiResponse<T> {
        // Create URLRequest
        var urlRequest = try endpoint.asURLRequest()

        // Apply interceptors (adapt phase)
        for interceptor in interceptors {
            urlRequest = try await interceptor.adapt(urlRequest)
        }

        NetworkLogger.logRequest(urlRequest)
        let startTime = Date()

        do {
            // Execute request
            let (data, response) = try await session.data(for: urlRequest)
            let duration = Date().timeIntervalSince(startTime)

            // Validate response
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            // Log response
            NetworkLogger.logResponse(
                data: data,
                response: response,
                request: urlRequest,
                duration: duration
            )

            // Decode response
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let apiResponse = try decoder.decode(ApiResponse<T>.self, from: data)

            // Check HTTP status code
            guard (200..<300).contains(httpResponse.statusCode) else {
                let error = mapStatusCodeToError(httpResponse.statusCode, message: apiResponse.message)

                // Try to retry with interceptors
                if !skipTokenRefresh {
                    for interceptor in interceptors {
                        let shouldRetry = try await interceptor.retry(
                            urlRequest,
                            for: error,
                            retryCount: retryCount
                        )

                        if shouldRetry {
                            // Retry request
                            return try await performRequest(
                                endpoint: endpoint,
                                retryCount: retryCount + 1,
                                skipTokenRefresh: skipTokenRefresh
                            )
                        }
                    }
                }

                throw error
            }

            // Check API success flag
            guard apiResponse.success else {
                throw mapStatusCodeToError(apiResponse.code, message: apiResponse.message)
            }

            return apiResponse

        } catch {
            let apiError = mapError(error)

            // Log error
            NetworkLogger.logError(apiError, request: urlRequest)

            // Try to retry with interceptors (for network errors)
            if !skipTokenRefresh && apiError.isRecoverable {
                for interceptor in interceptors {
                    let shouldRetry = try await interceptor.retry(
                        urlRequest,
                        for: apiError,
                        retryCount: retryCount
                    )

                    if shouldRetry {
                        return try await performRequest(
                            endpoint: endpoint,
                            retryCount: retryCount + 1,
                            skipTokenRefresh: skipTokenRefresh
                        )
                    }
                }
            }

            throw apiError
        }
    }

    // MARK: - Public Request Methods (Async/Await)

    func request<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) async throws -> T {
        let apiResponse: ApiResponse<T> = try await performRequest(endpoint: endpoint)
        return try apiResponse.getData()
    }

    func requestWithFullResponse<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) async throws -> ApiResponse<T> {
        return try await performRequest(endpoint: endpoint)
    }

    // MARK: - Combine Publisher

    func download<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) -> AnyPublisher<T, APIError> {

        guard var request = try? endpoint.asURLRequest() else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }

        // Note: Interceptors are not fully supported in Combine publisher
        // For full interceptor support, use async/await methods
        if let token = getJWTToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        NetworkLogger.logRequest(request)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let startTime = Date()

        return session.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { [weak self] data, response -> Data in
                let duration = Date().timeIntervalSince(startTime)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }

                NetworkLogger.logResponse(
                    data: data,
                    response: response,
                    request: request,
                    duration: duration
                )

                guard (200..<300).contains(httpResponse.statusCode) else {
                    let message = try? JSONDecoder().decode(ApiResponse<T>.self, from: data).message
                    throw self?.mapStatusCodeToError(httpResponse.statusCode, message: message) ?? .invalidResponse
                }

                return data
            }
            .decode(type: ApiResponse<T>.self, decoder: decoder)
            .tryMap { apiResponse -> T in
                guard apiResponse.success else {
                    throw APIError.serverError(
                        statusCode: apiResponse.code,
                        message: apiResponse.message
                    )
                }

                return try apiResponse.getData()
            }
            .mapError { [weak self] error -> APIError in
                let apiError = self?.mapError(error) ?? .networkError(error)
                NetworkLogger.logError(apiError, request: request)
                return apiError
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
