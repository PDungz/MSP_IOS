//
//  Untitled.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 20/10/25.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()

    private let session: URLSession
    private let secureStorage = SecureStorage.shared

    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = APIConfig.requestTimeout
        config.timeoutIntervalForResource = APIConfig.resourceTimeout
        session = URLSession(configuration: config)
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

    // MARK: - Private Helpers

    private func addAuthHeaderIfNeeded(to request: inout URLRequest) {
        if let token = getJWTToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }

    // MARK: - Generic Request (Async/Await)

    func request<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) async throws -> T {
        var request = try endpoint.asURLRequest()
        addAuthHeaderIfNeeded(to: &request)

        // ✅ Log request
        NetworkLogger.logRequest(request)

        let startTime = Date()

        do {
            let (data, response) = try await session.data(for: request)

            let duration = Date().timeIntervalSince(startTime)

            // ✅ Log response
            NetworkLogger.logResponse(
                data: data,
                response: response,
                request: request,
                duration: duration
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let apiResponse = try decoder.decode(ApiResponse<T>.self, from: data)

            // Check HTTP status
            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                // Handle 401 Unauthorized
                if httpResponse.statusCode == 401 {
                    AppLogger.w("Unauthorized - Token may be expired")
                    throw APIError.unauthorized
                }

                throw APIError.serverError(
                    statusCode: httpResponse.statusCode,
                    message: apiResponse.message
                )
            }

            // Check success field
            guard apiResponse.success else {
                throw APIError.serverError(
                    statusCode: apiResponse.code,
                    message: apiResponse.message
                )
            }

            return try apiResponse.getData()

        } catch let error as APIError {
            // ✅ Log error
            NetworkLogger.logError(error, request: request)
            throw error
        } catch let decodingError as DecodingError {
            // ✅ Log decoding error
            NetworkLogger.logError(decodingError, request: request)
            throw APIError.decodingError(decodingError)
        } catch {
            // ✅ Log unknown error
            NetworkLogger.logError(error, request: request)
            throw APIError.networkError(error)
        }
    }

    // MARK: - Request với Full Response

    func requestWithFullResponse<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) async throws -> ApiResponse<T> {
        var request = try endpoint.asURLRequest()
        addAuthHeaderIfNeeded(to: &request)

        // ✅ Log request
        NetworkLogger.logRequest(request)

        let startTime = Date()

        do {
            let (data, response) = try await session.data(for: request)

            let duration = Date().timeIntervalSince(startTime)

            // ✅ Log response
            NetworkLogger.logResponse(
                data: data,
                response: response,
                request: request,
                duration: duration
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let apiResponse = try decoder.decode(ApiResponse<T>.self, from: data)

            guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                if httpResponse.statusCode == 401 {
                    AppLogger.w("Unauthorized - Token may be expired")
                    throw APIError.unauthorized
                }

                throw APIError.serverError(
                    statusCode: httpResponse.statusCode,
                    message: apiResponse.message
                )
            }

            return apiResponse

        } catch let error as APIError {
            NetworkLogger.logError(error, request: request)
            throw error
        } catch {
            NetworkLogger.logError(error, request: request)
            throw APIError.networkError(error)
        }
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

        addAuthHeaderIfNeeded(to: &request)

        // ✅ Log request
        NetworkLogger.logRequest(request)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let startTime = Date()

        return session.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { data, response -> Data in
                let duration = Date().timeIntervalSince(startTime)

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }

                // ✅ Log response
                NetworkLogger.logResponse(
                    data: data,
                    response: response,
                    request: request,
                    duration: duration
                )

                guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    if httpResponse.statusCode == 401 {
                        AppLogger.w("Unauthorized - Token may be expired")
                        throw APIError.unauthorized
                    }

                    throw APIError.serverError(
                        statusCode: httpResponse.statusCode,
                        message: nil
                    )
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
            .mapError { error -> APIError in
                // ✅ Log error
                NetworkLogger.logError(error, request: request)

                if let apiError = error as? APIError {
                    return apiError
                } else if error is DecodingError {
                    return .decodingError(error)
                } else {
                    return .networkError(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
