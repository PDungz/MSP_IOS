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

    override init() {
        super.init()
        checkAuthStatus()
    }

    func login(username: String, password: String) async throws -> AuthData {
        guard !username.isEmpty, !password.isEmpty else {
            throw APIError.serverError(statusCode: 400, message: "Empty credentials")
        }

        AppLogger.i("Login attempt: \(username)")

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
