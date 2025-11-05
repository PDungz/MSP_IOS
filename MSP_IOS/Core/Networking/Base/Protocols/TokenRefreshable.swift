//
//  TokenRefreshable.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 05/11/25.
//

import Foundation

/// Protocol định nghĩa khả năng refresh access token
///
/// # Overview
/// Protocol này được sử dụng để implement token refresh mechanism.
/// Khi access token hết hạn (401 Unauthorized), class conform protocol này
/// sẽ tự động làm mới token bằng refresh token.
///
/// # Requirements
/// - Protocol này bắt buộc phải là class-bound (AnyObject) để có thể sử dụng weak references
/// - Implementation phải thread-safe để tránh multiple refresh calls
///
/// # Example
/// ```swift
/// class NetworkManager: TokenRefreshable {
///     func refreshToken() async throws -> (accessToken: String, refreshToken: String?) {
///         // Call refresh token API
///         // Return new tokens
///     }
/// }
/// ```
///
/// - Important: Must be class-bound (AnyObject) for weak references in interceptors
/// - Note: Implementation should prevent multiple simultaneous refresh attempts
protocol TokenRefreshable: AnyObject {

    /// Làm mới access token sử dụng refresh token
    ///
    /// Method này sẽ được gọi tự động khi nhận response 401 Unauthorized.
    /// Implementation nên:
    /// - Kiểm tra xem đã có refresh request đang chạy chưa
    /// - Gọi API refresh token với refresh token hiện tại
    /// - Lưu tokens mới vào secure storage
    /// - Return tokens mới
    ///
    /// - Returns: Tuple chứa (accessToken, refreshToken mới nếu có)
    /// - Throws: `APIError.tokenRefreshFailed` nếu không thể refresh
    ///
    /// # Example
    /// ```swift
    /// let (newAccessToken, newRefreshToken) = try await refreshToken()
    /// // Tokens đã được lưu và request gốc sẽ được retry
    /// ```
    func refreshToken() async throws -> (accessToken: String, refreshToken: String?)
}
