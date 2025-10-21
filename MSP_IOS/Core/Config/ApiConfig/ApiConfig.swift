//
//  api_endpoint.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 20/10/25.
//

import Foundation

struct APIConfig {

    // MARK: - Environment
    enum Environment {
        case development
        case staging
        case production

        static var current: Environment {
            #if DEBUG
            return .development
            #else
            return .production
            #endif
        }
    }

    // MARK: - Base URLs
    static var gatewayBaseURL: String {
        switch Environment.current {
        case .development:
            return "http://localhost:8080"
        case .staging:
            return "https://staging-api.myapp.com"
        case .production:
            return "https://api.myapp.com"
        }
    }

    // MARK: - Service Paths
    private static let authServicePath = "/api/auth"
    private static let userServicePath = "/api/users"

    // MARK: - Endpoints
    enum Endpoint {
        // Auth Service
        case login
        case register
        case refreshToken
        case logout
        case validateToken(token: String)
        case authHealth

        // User Service
        case getAllUsers
        case getUserById(id: Int)
        case getUserByUsername(username: String)
        case getUserPermissions(username: String)
        case updateUser(id: Int)
        case deleteUser(id: Int)
        case assignRoles(userId: Int)
        case userHealth

        var path: String {
            switch self {
            case .login:
                return "\(authServicePath)/login"
            case .register:
                return "\(authServicePath)/register"
            case .refreshToken:
                return "\(authServicePath)/refresh"
            case .logout:
                return "\(authServicePath)/logout"
            case .validateToken(let token):
                return "\(authServicePath)/validate?token=\(token)"
            case .authHealth:
                return "\(authServicePath)/health"
            case .getAllUsers:
                return "\(userServicePath)/"
            case .getUserById(let id):
                return "\(userServicePath)/\(id)"
            case .getUserByUsername(let username):
                return "\(userServicePath)/username/\(username)"
            case .getUserPermissions(let username):
                return "\(userServicePath)/\(username)/permissions"
            case .updateUser(let id):
                return "\(userServicePath)/\(id)"
            case .deleteUser(let id):
                return "\(userServicePath)/\(id)"
            case .assignRoles(let userId):
                return "\(userServicePath)/\(userId)/roles"
            case .userHealth:
                return "\(userServicePath)/health"
            }
        }

        var fullURL: String {
            return gatewayBaseURL + path
        }

        var requiresAuth: Bool {
            switch self {
            case .login, .register, .refreshToken, .validateToken, .authHealth:
                return false
            case .logout:
                return true
            case .getAllUsers, .getUserById, .getUserByUsername,
                 .getUserPermissions, .updateUser, .deleteUser,
                 .assignRoles, .userHealth:
                return true
            }
        }
    }

    // MARK: - Common Headers
    static var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    // MARK: - Timeout
    static let requestTimeout: TimeInterval = 30
    static let resourceTimeout: TimeInterval = 60
}

