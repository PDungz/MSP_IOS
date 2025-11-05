//
//  NetworkManagerProtocol.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 05/11/25.
//

import Foundation
import Combine

/// Protocol defining network manager interface for dependency injection and testing
protocol NetworkManagerProtocol {
    // MARK: - Token Management
    func setTokens(jwt: String, refresh: String?)
    func clearTokens()
    func hasValidToken() -> Bool

    // MARK: - Request Methods
    func request<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) async throws -> T

    func requestWithFullResponse<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) async throws -> ApiResponse<T>

    func download<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) -> AnyPublisher<T, APIError>
}

/// Protocol for token refresh functionality
/// Note: Must be class-bound for weak references in interceptors
protocol TokenRefreshable: AnyObject {
    func refreshToken() async throws -> (accessToken: String, refreshToken: String?)
}
