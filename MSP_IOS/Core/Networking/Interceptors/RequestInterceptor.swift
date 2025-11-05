//
//  RequestInterceptor.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 05/11/25.
//

import Foundation

/// Protocol for intercepting and modifying requests before they're sent
protocol RequestInterceptor {
    /// Adapt URLRequest before sending (e.g., add headers, modify body)
    func adapt(_ urlRequest: URLRequest) async throws -> URLRequest

    /// Retry request if it failed
    func retry(
        _ request: URLRequest,
        for error: APIError,
        retryCount: Int
    ) async throws -> Bool
}

/// Default request interceptor with auth and retry logic
class DefaultRequestInterceptor: RequestInterceptor {
    private let maxRetryCount: Int
    private let retryableStatusCodes: Set<Int>
    private weak var tokenRefreshable: TokenRefreshable?

    init(
        maxRetryCount: Int = 3,
        retryableStatusCodes: Set<Int> = [408, 429, 500, 502, 503, 504],
        tokenRefreshable: TokenRefreshable? = nil
    ) {
        self.maxRetryCount = maxRetryCount
        self.retryableStatusCodes = retryableStatusCodes
        self.tokenRefreshable = tokenRefreshable
    }

    func adapt(_ urlRequest: URLRequest) async throws -> URLRequest {
        // Default implementation - can be overridden
        return urlRequest
    }

    func retry(
        _ request: URLRequest,
        for error: APIError,
        retryCount: Int
    ) async throws -> Bool {
        // Don't retry if max retries exceeded
        guard retryCount < maxRetryCount else {
            AppLogger.w("Max retry count exceeded for request")
            return false
        }

        // Handle 401 Unauthorized - try to refresh token
        if error == .unauthorized, let tokenRefreshable = tokenRefreshable {
            AppLogger.i("Attempting to refresh token (retry \(retryCount + 1)/\(maxRetryCount))")

            do {
                _ = try await tokenRefreshable.refreshToken()
                AppLogger.s("Token refreshed successfully")
                return true
            } catch {
                AppLogger.e("Token refresh failed: \(error.localizedDescription)")
                throw APIError.tokenRefreshFailed
            }
        }

        // Retry for recoverable errors
        if error.isRecoverable {
            let delay = exponentialBackoff(retryCount: retryCount)
            AppLogger.i("Retrying request after \(delay)s (retry \(retryCount + 1)/\(maxRetryCount))")

            try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            return true
        }

        // Don't retry for non-recoverable errors
        return false
    }

    /// Calculate exponential backoff delay
    private func exponentialBackoff(retryCount: Int) -> TimeInterval {
        let baseDelay: TimeInterval = 1.0
        let maxDelay: TimeInterval = 32.0
        let delay = min(baseDelay * pow(2.0, Double(retryCount)), maxDelay)

        // Add jitter (±25%)
        let jitter = delay * Double.random(in: -0.25...0.25)
        return delay + jitter
    }
}

/// Auth interceptor - automatically adds Bearer token
///
/// # Overview
/// Tự động thêm Bearer token vào Authorization header cho các requests cần authentication.
/// SKIP các endpoints không cần auth như: login, register, refresh token.
///
/// # Excluded Endpoints
/// - `/api/auth/login` - Login không cần token
/// - `/api/auth/register` - Register không cần token
/// - `/api/auth/refresh` - Refresh dùng refresh_token trong body, không dùng Bearer token
class AuthInterceptor: RequestInterceptor {
    private let secureStorage = SecureStorage.shared

    /// Endpoints không cần Authorization header
    private let excludedPaths: Set<String> = [
        "/api/auth/login",
        "/api/auth/register",
        "/api/auth/refresh"
    ]

    func adapt(_ urlRequest: URLRequest) async throws -> URLRequest {
        var request = urlRequest

        // Check if endpoint needs authentication
        guard let url = request.url,
              !shouldSkipAuth(for: url) else {
            AppLogger.i("Skipping auth token for: \(request.url?.path ?? "unknown")")
            return request
        }

        // Add Bearer token if available
        if let token = secureStorage.loadString(forKey: StorageKeys.Auth.jwtToken) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            AppLogger.i("Added Bearer token to request")
        }

        return request
    }

    /// Check if request should skip authentication
    private func shouldSkipAuth(for url: URL) -> Bool {
        let path = url.path
        return excludedPaths.contains(path)
    }

    func retry(
        _ request: URLRequest,
        for error: APIError,
        retryCount: Int
    ) async throws -> Bool {
        // Auth interceptor doesn't handle retry logic
        return false
    }
}

/// Logging interceptor - logs all requests and responses
class LoggingInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest) async throws -> URLRequest {
        NetworkLogger.logRequest(urlRequest)
        return urlRequest
    }

    func retry(
        _ request: URLRequest,
        for error: APIError,
        retryCount: Int
    ) async throws -> Bool {
        return false
    }
}
