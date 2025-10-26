//
//  AuthService.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 20/10/25.
//

import Combine
import Foundation

import Foundation

class AuthService: BaseService {
    @Published var isAuthenticated = false
    @Published var currentUser: AuthData?

    // Mock mode for testing without server
    var isMockMode = true // Set to false to use real API

    // Mock data for testing
    private let mockAuthData = AuthData(
        accessToken: "mock_access_token_12345",
        refreshToken: "mock_refresh_token_67890",
        tokenType: "Bearer",
        expiresIn: 3600,
        username: "user",
        email: "test@example.com",
        phoneNumber: "0123456789"
    )

    override init() {
        super.init()
        checkAuthStatus()
    }

    func login(username: String, password: String) async throws -> AuthData {
        guard !username.isEmpty, !password.isEmpty else {
            throw APIError.serverError(statusCode: 400, message: "Empty credentials")
        }

        AppLogger.i("Login attempt: \(username)")

        // Mock mode: return fake data without calling API
        if isMockMode {
            AppLogger.i("🧪 Mock mode enabled - simulating login")

            // Simulate network delay
            try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

            // Mock validation: accept any non-empty credentials
            // You can add custom validation here if needed
            // Example: if username == "admin" && password == "admin" { ... }

            let authData = mockAuthData

            networkManager.setTokens(jwt: authData.accessToken, refresh: authData.refreshToken)
            saveUserData(authData)

            await MainActor.run {
                isAuthenticated = true
                currentUser = authData
            }

            AppLogger.s("🧪 Mock login successful: \(authData.username)")
            return authData
        }

        // Real API mode
        let credentials = LoginRequest(username: username, password: password)
        let request = LoginAPIRequest(credentials: credentials)

        // ✅ Use BaseService helper
        let (authData, _) = try await executeRequestWithFullResponse(
            endpoint: request,
            responseType: AuthResponse.self
        )

        networkManager.setTokens(jwt: authData.accessToken, refresh: authData.refreshToken)
        saveUserData(authData)

        await MainActor.run {
            isAuthenticated = true
            currentUser = authData
        }

        AppLogger.s("Login successful: \(authData.username)")

        return authData
    }

    func logout() {
        networkManager.clearTokens()
        clearUserData()
        isAuthenticated = false
        currentUser = nil
        AppLogger.s("Logged out")
    }

    func checkAuthStatus() {
        guard networkManager.hasValidToken(),
              let authData = loadUserData(),
              isTokenValid() else {
            isAuthenticated = false
            return
        }

        currentUser = authData
        isAuthenticated = true
        AppLogger.s("Session restored: \(authData.username)")
    }

    // Helper methods (same as standalone version)
    private func saveUserData(_ authData: AuthData) {
       _ = secureStorage.save(authData, forKey: StorageKeys.Auth.userData)
        let expirationDate = Date().addingTimeInterval(TimeInterval(authData.expiresIn))
       _ = secureStorage.save(expirationDate, forKey: StorageKeys.Auth.tokenExpiration)
    }

    private func loadUserData() -> AuthData? {
        return secureStorage.load(forKey: StorageKeys.Auth.userData, as: AuthData.self)
    }

    private func clearUserData() {
        secureStorage.delete(forKey: StorageKeys.Auth.userData)
        secureStorage.delete(forKey: StorageKeys.Auth.tokenExpiration)
    }

    private func isTokenValid() -> Bool {
        guard let expirationDate = secureStorage.load(
            forKey: StorageKeys.Auth.tokenExpiration,
            as: Date.self
        ) else {
            return false
        }
        return expirationDate > Date()
    }
}
