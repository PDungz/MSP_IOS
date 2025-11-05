//
//  NetworkManagerProtocol.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 05/11/25.
//

import Foundation
import Combine

/// Protocol định nghĩa interface cho Network Manager
///
/// # Overview
/// Protocol này cung cấp abstraction layer cho network operations,
/// giúp dễ dàng testing và dependency injection.
///
/// # Key Features
/// - Token management (save, clear, validate)
/// - Async/await request methods
/// - Combine publisher support
/// - Generic type-safe responses
///
/// # Usage
/// ```swift
/// class MyService {
///     let networkManager: NetworkManagerProtocol
///
///     init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
///         self.networkManager = networkManager
///     }
///
///     func fetchData() async throws -> User {
///         return try await networkManager.request(
///             endpoint: GetUserEndpoint(),
///             responseType: ApiResponse<User>.self
///         )
///     }
/// }
/// ```
///
/// - Note: Use this protocol for dependency injection and testing
/// - SeeAlso: `NetworkManager` for concrete implementation
protocol NetworkManagerProtocol {

    // MARK: - Token Management

    /// Lưu authentication tokens vào secure storage
    ///
    /// Tokens sẽ được encrypt và lưu vào Keychain an toàn.
    ///
    /// - Parameters:
    ///   - jwt: Access token (JWT)
    ///   - refresh: Refresh token (optional)
    ///
    /// # Example
    /// ```swift
    /// networkManager.setTokens(
    ///     jwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    ///     refresh: "refresh_token_here"
    /// )
    /// ```
    func setTokens(jwt: String, refresh: String?)

    /// Xóa tất cả authentication tokens
    ///
    /// Method này sẽ:
    /// - Xóa access token và refresh token khỏi secure storage
    /// - Cancel pending refresh token tasks
    /// - Reset refresh state
    ///
    /// # Example
    /// ```swift
    /// // Khi user logout
    /// networkManager.clearTokens()
    /// ```
    func clearTokens()

    /// Kiểm tra xem có token hợp lệ hay không
    ///
    /// - Returns: `true` nếu access token tồn tại trong storage
    ///
    /// # Example
    /// ```swift
    /// if networkManager.hasValidToken() {
    ///     // User đã login
    /// } else {
    ///     // Redirect to login
    /// }
    /// ```
    func hasValidToken() -> Bool

    // MARK: - Request Methods

    /// Thực hiện network request và return data đã unwrap
    ///
    /// Method này sẽ:
    /// 1. Tạo URLRequest từ endpoint
    /// 2. Apply interceptor chain (auth, retry, logging)
    /// 3. Execute request
    /// 4. Decode response
    /// 5. Validate và unwrap data
    /// 6. Auto retry nếu có lỗi recoverable
    /// 7. Auto refresh token nếu 401
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint conform `APIEndpoint` protocol
    ///   - responseType: Type của response wrapper (ApiResponse<T>)
    ///
    /// - Returns: Data đã được unwrap từ response
    /// - Throws: `APIError` nếu request fails
    ///
    /// # Example
    /// ```swift
    /// let user = try await networkManager.request(
    ///     endpoint: GetUserEndpoint(id: 123),
    ///     responseType: ApiResponse<User>.self
    /// )
    /// // user là User object, không phải ApiResponse<User>
    /// ```
    ///
    /// - Important: Sử dụng method này khi chỉ cần data, không cần message
    func request<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) async throws -> T

    /// Thực hiện network request và return full response
    ///
    /// Method này tương tự `request()` nhưng return toàn bộ ApiResponse
    /// để có thể access message, code, timestamp.
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint conform `APIEndpoint` protocol
    ///   - responseType: Type của response wrapper
    ///
    /// - Returns: Full `ApiResponse<T>` object
    /// - Throws: `APIError` nếu request fails
    ///
    /// # Example
    /// ```swift
    /// let response = try await networkManager.requestWithFullResponse(
    ///     endpoint: LoginEndpoint(credentials: creds),
    ///     responseType: ApiResponse<AuthData>.self
    /// )
    /// print(response.message) // "Login successful"
    /// let authData = try response.getData()
    /// ```
    ///
    /// - Note: Sử dụng khi cần access message hoặc metadata
    func requestWithFullResponse<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) async throws -> ApiResponse<T>

    /// Thực hiện request sử dụng Combine Publisher
    ///
    /// Method này cung cấp reactive approach sử dụng Combine framework.
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint conform `APIEndpoint` protocol
    ///   - responseType: Type của response wrapper
    ///
    /// - Returns: Publisher emit data hoặc error
    ///
    /// # Example
    /// ```swift
    /// networkManager.download(
    ///     endpoint: GetUserEndpoint(),
    ///     responseType: ApiResponse<User>.self
    /// )
    /// .sink(
    ///     receiveCompletion: { completion in
    ///         if case .failure(let error) = completion {
    ///             print("Error: \(error)")
    ///         }
    ///     },
    ///     receiveValue: { user in
    ///         print("User: \(user)")
    ///     }
    /// )
    /// .store(in: &cancellables)
    /// ```
    ///
    /// - Warning: Interceptors không fully supported trong Combine publisher
    /// - Note: Prefer async/await methods cho full feature support
    func download<T: Codable>(
        endpoint: any APIEndpoint,
        responseType: ApiResponse<T>.Type
    ) -> AnyPublisher<T, APIError>
}
