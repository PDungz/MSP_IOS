//
//  AppState.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//  Simplified to only handle authentication state
//

import SwiftUI
import Combine

/// Simplified AppState - only manages authentication
///
/// Navigation is now handled by centralized AppNavigation system
final class AppState: ObservableObject {

    @Published var isAuthenticated: Bool = false

    // ✅ AuthService as single source of truth
    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupAuthObserver()
        checkInitialAuthStatus()
    }

    // MARK: - Auth Observer

    /// Observe AuthService changes and update UI accordingly
    private func setupAuthObserver() {
        authService.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                self?.isAuthenticated = isAuthenticated
                AppLogger.i("🔐 Auth state changed: \(isAuthenticated)")

                // ✅ Navigate based on auth state
                if isAuthenticated {
                    AppNavigation.navigateToHome()
                } else {
                    AppNavigation.navigateToLogin()
                }
            }
            .store(in: &cancellables)
    }

    // ✅ Check auth status on app launch
    private func checkInitialAuthStatus() {
        authService.checkAuthStatus()
    }

    // MARK: - Public Methods

    /// Logout method
    func logout() {
        authService.logout()
        AppNavigation.navigateToLogin()
        AppLogger.s("🔓 Logout triggered from AppState")
    }

    /// Expose AuthService for ViewModels
    var auth: AuthService {
        return authService
    }
}
