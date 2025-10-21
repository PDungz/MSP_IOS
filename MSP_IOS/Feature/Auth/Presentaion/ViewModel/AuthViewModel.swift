//
//  AuthViewModel.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 19/10/25.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    // ✅ Inject AuthService from AppState
    private let authService: AuthService

    // MARK: - Initialization

    init(authService: AuthService) {
        self.authService = authService
    }

    // MARK: - Login Method

    func login() async -> Bool {
        // Clear previous messages
        clearError()

        // Validate input
        guard !username.isEmpty else {
            errorMessage = NSLocalizedString("login_username_required", comment: "Username is required")
            return false
        }

        guard !password.isEmpty else {
            errorMessage = NSLocalizedString("login_password_required", comment: "Password is required")
            return false
        }

        isLoading = true

        do {
            // ✅ Call AuthService
            let authData = try await authService.login(
                username: username,
                password: password
            )

            isLoading = false
            successMessage = authService.successMessage

            AppLogger.s("""
            Login successful in ViewModel
            User: \(authData.username)
            Email: \(authData.email)
            """)

            // ✅ Clear form after successful login
            clearForm()

            return true

        } catch let error as APIError {
            isLoading = false
            errorMessage = error.localizedDescription

            AppLogger.e("Login failed in ViewModel: \(error.localizedDescription)")

            return false

        } catch {
            isLoading = false
            errorMessage = NSLocalizedString("login_unknown_error", comment: "Unknown error occurred")

            AppLogger.e("Unknown error: \(error)")

            return false
        }
    }

    // MARK: - Helper Methods

    func clearError() {
        errorMessage = nil
        successMessage = nil
    }

    func clearForm() {
        username = ""
        password = ""
        errorMessage = nil
        successMessage = nil
    }

    // ✅ Check authentication status
    func checkAuthStatus() {
        authService.checkAuthStatus()
    }

    // ✅ Get current user
    var currentUser: AuthData? {
        return authService.currentUser
    }

    // ✅ Check if authenticated
    var isAuthenticated: Bool {
        return authService.isAuthenticated
    }
}
