//
//  User.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 19/10/25.
//

import Foundation

// MARK: - Login Request
struct LoginRequest: Codable {
    let username: String
    let password: String
}

// MARK: - Refresh Token Request
struct RefreshTokenRequest: APIEndpoint {
    let refreshToken: String

    var path: String {
        return APIConfig.Endpoint.refreshToken.path
    }

    var method: HTTPMethod {
        return .post
    }

    var body: Data? {
        let payload = ["refresh_token": refreshToken]
        return try? JSONSerialization.data(withJSONObject: payload)
    }
}

// MARK: - Auth Data (từ response)
struct AuthData: Codable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    let username: String
    let email: String
    let phoneNumber: String?
}

// MARK: - Type Alias
typealias AuthResponse = ApiResponse<AuthData>
