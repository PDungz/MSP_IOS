//
//  AppState.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI
import Combine

final class AppState: ObservableObject {

    @Published var isAuthenticated: Bool = false
    @Published var router: Router

    // ✅ AuthService as single source of truth
    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()

    lazy var authCoordinator: AuthCoordinator = {
        AuthCoordinator(router: router, appState: self)
    }()

    lazy var homeCoordinator: HomeCoordinator = {
        HomeCoordinator(router: router, appState: self)
    }()

    init() {
        self.router = Router()
        setupAuthObserver()
        checkInitialAuthStatus()
    }

    // ✅ Observe AuthService changes
    private func setupAuthObserver() {
        authService.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthenticated in
                self?.isAuthenticated = isAuthenticated
                AppLogger.i("Auth state changed: \(isAuthenticated)")
            }
            .store(in: &cancellables)
    }

    // ✅ Check auth status on app launch
    private func checkInitialAuthStatus() {
        authService.checkAuthStatus()
    }

    // ✅ Login method (delegate to AuthService)
    func login() {
        // This will be called from LoginView after successful API login
        // No need to set isAuthenticated here - it's synced from AuthService
        AppLogger.s("Login triggered from AppState")
    }

    // ✅ Logout method
    func logout() {
        authService.logout()
        router.clear()
        AppLogger.s("Logout triggered from AppState")
    }

    // ✅ Expose AuthService for ViewModels
    var auth: AuthService {
        return authService
    }
}
