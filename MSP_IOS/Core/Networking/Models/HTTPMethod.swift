//
//  HTTPMethod.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 20/10/25.
//  Updated on 05/11/25 - Added comprehensive documentation
//

import Foundation

/// HTTP methods được support bởi API
///
/// # Overview
/// Enum này định nghĩa các HTTP methods theo chuẩn RFC 7231.
/// Sử dụng enum (không phải functions) vì:
/// - Type-safe: Compiler check tại compile time
/// - Closed set: Chỉ cho phép các giá trị được định nghĩa
/// - Pattern matching: Dễ dàng sử dụng trong switch
/// - Standardized: Follow iOS và Swift conventions
///
/// # Usage
/// ```swift
/// struct MyEndpoint: APIEndpoint {
///     var method: HTTPMethod { .get }  // Hoặc .post, .put, .delete, .patch
/// }
/// ```
///
/// # Semantic Meaning
/// - **GET**: Đọc/lấy dữ liệu (idempotent, safe)
/// - **POST**: Tạo mới resource hoặc execute action (non-idempotent)
/// - **PUT**: Update/replace toàn bộ resource (idempotent)
/// - **PATCH**: Update partial resource (non-idempotent thường)
/// - **DELETE**: Xóa resource (idempotent)
///
/// - Note: Enum approach is preferred over functions for type safety
/// - SeeAlso: [RFC 7231](https://tools.ietf.org/html/rfc7231#section-4.3)
enum HTTPMethod: String, CaseIterable {

    /// GET method - Đọc/lấy dữ liệu từ server
    ///
    /// # Characteristics
    /// - Safe: Không thay đổi state trên server
    /// - Idempotent: Multiple identical requests có same effect như single request
    /// - Cacheable: Response có thể được cache
    ///
    /// # Use Cases
    /// - Lấy danh sách: `GET /api/users`
    /// - Lấy chi tiết: `GET /api/users/123`
    /// - Search/filter: `GET /api/users?search=john&page=1`
    ///
    /// # Example
    /// ```swift
    /// struct GetUsersEndpoint: APIEndpoint {
    ///     var path: String { "/api/users" }
    ///     var method: HTTPMethod { .get }
    ///     var parameters: [String: Any]? {
    ///         return ["page": 1, "limit": 20]
    ///     }
    /// }
    /// ```
    ///
    /// - Important: GET requests không nên có body
    /// - Note: Parameters sẽ được encode vào query string
    case get = "GET"

    /// POST method - Tạo mới resource hoặc execute action
    ///
    /// # Characteristics
    /// - Not safe: Thay đổi state trên server
    /// - Not idempotent: Multiple requests tạo multiple resources
    /// - Not cacheable: Response thường không được cache
    ///
    /// # Use Cases
    /// - Tạo resource: `POST /api/users` với body là user data
    /// - Login: `POST /api/auth/login` với credentials
    /// - Execute action: `POST /api/orders/123/cancel`
    ///
    /// # Example
    /// ```swift
    /// struct CreateUserEndpoint: APIEndpoint {
    ///     let userData: UserCreateRequest
    ///
    ///     var path: String { "/api/users" }
    ///     var method: HTTPMethod { .post }
    ///     var body: Data? {
    ///         try? JSONEncoder().encode(userData)
    ///     }
    /// }
    /// ```
    ///
    /// - Note: Thường return newly created resource trong response
    case post = "POST"

    /// PUT method - Update/replace toàn bộ resource
    ///
    /// # Characteristics
    /// - Not safe: Thay đổi state trên server
    /// - Idempotent: Multiple identical requests có same effect
    /// - Not cacheable: Response thường không được cache
    ///
    /// # Use Cases
    /// - Replace toàn bộ resource: `PUT /api/users/123` với full user data
    /// - Update all fields: Client gửi complete representation
    ///
    /// # Example
    /// ```swift
    /// struct UpdateUserEndpoint: APIEndpoint {
    ///     let userId: Int
    ///     let userData: User  // Full user object
    ///
    ///     var path: String { "/api/users/\(userId)" }
    ///     var method: HTTPMethod { .put }
    ///     var body: Data? {
    ///         try? JSONEncoder().encode(userData)
    ///     }
    /// }
    /// ```
    ///
    /// - Important: PUT thường yêu cầu gửi TOÀN BỘ resource data
    /// - Note: Nếu chỉ update một vài fields, xem xét dùng PATCH
    case put = "PUT"

    /// DELETE method - Xóa resource
    ///
    /// # Characteristics
    /// - Not safe: Thay đổi state trên server (xóa data)
    /// - Idempotent: Multiple identical deletes có same effect (resource đã xóa)
    /// - Not cacheable: Response không được cache
    ///
    /// # Use Cases
    /// - Xóa resource: `DELETE /api/users/123`
    /// - Xóa nhiều: `DELETE /api/users` với body là list IDs
    ///
    /// # Example
    /// ```swift
    /// struct DeleteUserEndpoint: APIEndpoint {
    ///     let userId: Int
    ///
    ///     var path: String { "/api/users/\(userId)" }
    ///     var method: HTTPMethod { .delete }
    /// }
    /// ```
    ///
    /// - Note: Thường return 204 No Content hoặc 200 OK với deleted resource
    case delete = "DELETE"

    /// PATCH method - Update một phần của resource
    ///
    /// # Characteristics
    /// - Not safe: Thay đổi state trên server
    /// - Generally not idempotent: Tùy implementation
    /// - Not cacheable: Response thường không được cache
    ///
    /// # Use Cases
    /// - Partial update: `PATCH /api/users/123` với chỉ fields cần update
    /// - Update specific fields: Client chỉ gửi changed fields
    ///
    /// # Example
    /// ```swift
    /// struct UpdateUserEmailEndpoint: APIEndpoint {
    ///     let userId: Int
    ///     let newEmail: String
    ///
    ///     var path: String { "/api/users/\(userId)" }
    ///     var method: HTTPMethod { .patch }
    ///     var parameters: [String: Any]? {
    ///         return ["email": newEmail]  // Chỉ update email
    ///     }
    /// }
    /// ```
    ///
    /// - Note: PATCH cho phép gửi partial data, khác với PUT
    /// - Important: Server cần support PATCH method
    case patch = "PATCH"

    // MARK: - Helper Properties

    /// Kiểm tra xem method có phải là safe method không
    ///
    /// Safe methods không thay đổi state trên server.
    ///
    /// - Returns: `true` nếu là GET (safe method)
    ///
    /// # Example
    /// ```swift
    /// if endpoint.method.isSafe {
    ///     print("Request này không thay đổi data")
    /// }
    /// ```
    var isSafe: Bool {
        return self == .get
    }

    /// Kiểm tra xem method có phải là idempotent không
    ///
    /// Idempotent methods: Multiple identical requests có same effect như single request.
    ///
    /// - Returns: `true` cho GET, PUT, DELETE
    ///
    /// # Example
    /// ```swift
    /// if endpoint.method.isIdempotent {
    ///     print("Safe to retry request này")
    /// }
    /// ```
    var isIdempotent: Bool {
        return self == .get || self == .put || self == .delete
    }

    /// Kiểm tra xem method có typically có request body không
    ///
    /// - Returns: `true` cho POST, PUT, PATCH
    ///
    /// # Example
    /// ```swift
    /// if endpoint.method.shouldHaveBody {
    ///     assert(endpoint.body != nil, "Missing request body")
    /// }
    /// ```
    var shouldHaveBody: Bool {
        return self == .post || self == .put || self == .patch
    }
}

// MARK: - CustomStringConvertible

extension HTTPMethod: CustomStringConvertible {
    /// Description cho debugging
    var description: String {
        return rawValue
    }
}
