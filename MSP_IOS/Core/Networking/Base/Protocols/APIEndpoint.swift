//
//  APIEndpoint.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 20/10/25.
//  Updated on 05/11/25 - Added comprehensive documentation
//

import Foundation

/// Protocol định nghĩa cấu trúc của một API endpoint
///
/// # Overview
/// Mọi API endpoint trong app đều phải conform protocol này.
/// Protocol cung cấp các thông tin cần thiết để construct một HTTP request.
///
/// # Required Properties
/// - `path`: Đường dẫn API (required)
/// - `method`: HTTP method (required)
///
/// # Optional Properties (có default implementation)
/// - `baseURL`: Base URL (default: từ APIConfig)
/// - `headers`: Custom headers (default: từ APIConfig)
/// - `parameters`: Query parameters hoặc body parameters
/// - `body`: Raw request body data
///
/// # Example
/// ```swift
/// struct GetUserEndpoint: APIEndpoint {
///     let userId: Int
///
///     var path: String {
///         return "/api/users/\(userId)"
///     }
///
///     var method: HTTPMethod {
///         return .get
///     }
/// }
///
/// struct CreateUserEndpoint: APIEndpoint {
///     let userData: UserCreateRequest
///
///     var path: String { "/api/users" }
///     var method: HTTPMethod { .post }
///
///     var body: Data? {
///         try? JSONEncoder().encode(userData)
///     }
/// }
/// ```
///
/// - SeeAlso: `HTTPMethod` for available HTTP methods
/// - SeeAlso: `NetworkManager.request()` for usage
protocol APIEndpoint {

    // MARK: - Required Properties

    /// Đường dẫn của API endpoint (không bao gồm base URL)
    ///
    /// Path sẽ được append vào `baseURL` để tạo full URL.
    ///
    /// # Examples
    /// - `/api/users` - List users
    /// - `/api/users/123` - Get user by ID
    /// - `/api/auth/login` - Login endpoint
    ///
    /// - Important: Path phải bắt đầu bằng `/`
    var path: String { get }

    /// HTTP method của request
    ///
    /// - SeeAlso: `HTTPMethod` enum
    var method: HTTPMethod { get }

    // MARK: - Optional Properties

    /// Base URL của API server
    ///
    /// Default implementation lấy từ `APIConfig.gatewayBaseURL`
    /// Override property này nếu muốn sử dụng base URL khác.
    ///
    /// # Example
    /// ```swift
    /// var baseURL: String {
    ///     return "https://custom-api.example.com"
    /// }
    /// ```
    var baseURL: String { get }

    /// Custom HTTP headers
    ///
    /// Default implementation lấy từ `APIConfig.defaultHeaders`
    /// Custom headers sẽ override default headers nếu trùng key.
    ///
    /// # Example
    /// ```swift
    /// var headers: [String: String]? {
    ///     return [
    ///         "Content-Type": "application/json",
    ///         "X-Custom-Header": "value"
    ///     ]
    /// }
    /// ```
    ///
    /// - Note: Authorization header sẽ được tự động thêm bởi AuthInterceptor
    var headers: [String: String]? { get }

    /// Query parameters (cho GET) hoặc body parameters (cho POST/PUT/PATCH)
    ///
    /// - For GET requests: Sẽ được encode thành query string
    /// - For POST/PUT/PATCH: Sẽ được serialize thành JSON body (nếu không có `body`)
    ///
    /// # Example - GET with query params
    /// ```swift
    /// var parameters: [String: Any]? {
    ///     return [
    ///         "page": 1,
    ///         "limit": 20,
    ///         "search": "john"
    ///     ]
    /// }
    /// // Result: /api/users?page=1&limit=20&search=john
    /// ```
    ///
    /// # Example - POST with JSON params
    /// ```swift
    /// var parameters: [String: Any]? {
    ///     return [
    ///         "username": "john",
    ///         "email": "john@example.com"
    ///     ]
    /// }
    /// // Result: Body = {"username":"john","email":"john@example.com"}
    /// ```
    ///
    /// - Note: Nếu có `body`, parameters sẽ bị ignore cho non-GET requests
    var parameters: [String: Any]? { get }

    /// Raw request body data
    ///
    /// Sử dụng property này khi muốn kiểm soát hoàn toàn body data,
    /// ví dụ: custom encoding, multipart form data, protobuf, etc.
    ///
    /// # Example - Codable object
    /// ```swift
    /// var body: Data? {
    ///     let encoder = JSONEncoder()
    ///     encoder.keyEncodingStrategy = .convertToSnakeCase
    ///     return try? encoder.encode(userData)
    /// }
    /// ```
    ///
    /// # Example - Multipart form
    /// ```swift
    /// var body: Data? {
    ///     var formData = Data()
    ///     // ... construct multipart form data
    ///     return formData
    /// }
    /// ```
    ///
    /// - Note: Priority: `body` > `parameters` cho non-GET requests
    var body: Data? { get }
}

// MARK: - Default Implementation

extension APIEndpoint {

    /// Default implementation: Sử dụng base URL từ APIConfig
    var baseURL: String {
        return APIConfig.gatewayBaseURL
    }

    /// Default implementation: Sử dụng headers từ APIConfig
    var headers: [String: String]? {
        return APIConfig.defaultHeaders
    }

    /// Default implementation: Không có parameters
    var parameters: [String: Any]? { nil }

    /// Default implementation: Không có body
    var body: Data? { nil }

    // MARK: - URLRequest Construction

    /// Convert endpoint thành URLRequest
    ///
    /// Method này xử lý:
    /// 1. Construct full URL từ baseURL + path
    /// 2. Append query parameters (cho GET requests)
    /// 3. Set HTTP method
    /// 4. Set headers (merge default + custom)
    /// 5. Set request body (raw body hoặc JSON-encoded parameters)
    /// 6. Set timeout interval
    ///
    /// - Returns: Configured URLRequest sẵn sàng để execute
    /// - Throws: `APIError.invalidURL` nếu không thể construct URL
    ///
    /// # Example
    /// ```swift
    /// let endpoint = GetUserEndpoint(userId: 123)
    /// let urlRequest = try endpoint.asURLRequest()
    /// // urlRequest.url = "https://api.example.com/api/users/123"
    /// // urlRequest.httpMethod = "GET"
    /// // urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json", ...]
    /// ```
    ///
    /// - Important: Method này được gọi internally bởi NetworkManager
    func asURLRequest() throws -> URLRequest {
        var urlString = baseURL + path

        // Append query parameters cho GET requests
        if method == .get, let params = parameters {
            var components = URLComponents(string: urlString)
            components?.queryItems = params.map {
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
            guard let url = components?.url else {
                throw APIError.invalidURL
            }
            urlString = url.absoluteString
        }

        // Validate URL
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        // Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = APIConfig.requestTimeout

        // Merge headers (custom headers override defaults)
        var allHeaders = APIConfig.defaultHeaders
        if let customHeaders = headers {
            allHeaders.merge(customHeaders) { _, new in new }
        }
        request.allHTTPHeaderFields = allHeaders

        // Set request body cho non-GET requests
        if method != .get {
            if let body = body {
                // Priority 1: Raw body data
                request.httpBody = body
            } else if let params = parameters {
                // Priority 2: JSON-encoded parameters
                request.httpBody = try? JSONSerialization.data(withJSONObject: params)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        return request
    }
}
