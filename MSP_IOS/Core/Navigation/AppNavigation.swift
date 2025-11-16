//
//  AppNavigation.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 05/11/25.
//  Navigation Helper - Static methods for easy navigation
//

import Foundation

/// Helper class cung cấp static methods để navigate
///
/// # Overview
/// Tương tự `DpAppNavigation` trong Flutter.
/// Cung cấp convenient static methods để navigate mà không cần access AppRouter.shared.
///
/// # Usage
/// ```swift
/// // Push
/// AppNavigation.push(.home)
/// AppNavigation.push(.userDetail(userId: "123"))
///
/// // Pop
/// AppNavigation.pop()
/// AppNavigation.popToRoot()
///
/// // Replace
/// AppNavigation.replace(with: .login)
/// ```
///
/// - Note: Tất cả methods đều delegate sang AppRouter.shared
/// - Important: App phải setup NavigationStack với AppRouter tại root level
struct AppNavigation {

    // MARK: - Basic Navigation

    /// Push một route lên stack
    ///
    /// Tương tự: `DpAppNavigation.pushNamed()` trong Flutter
    ///
    /// - Parameter route: Route muốn navigate tới
    ///
    /// # Example
    /// ```swift
    /// AppNavigation.push(.home)
    /// AppNavigation.push(.userDetail(userId: "123"))
    /// ```
    static func push(_ route: AppRoute) {
        AppRouter.shared.push(route)
    }

    /// Pop back một màn hình
    ///
    /// Tương tự: `DpAppNavigation.pop()` trong Flutter
    ///
    /// # Example
    /// ```swift
    /// AppNavigation.pop()
    /// ```
    static func pop() {
        AppRouter.shared.pop()
    }

    /// Pop về root (xóa toàn bộ stack)
    ///
    /// Tương tự: `DpAppNavigation.clearStackAndGo()` trong Flutter
    ///
    /// # Example
    /// ```swift
    /// AppNavigation.popToRoot()
    /// ```
    static func popToRoot() {
        AppRouter.shared.popToRoot()
    }

    /// Replace current route với route mới
    ///
    /// Tương tự: `DpAppNavigation.pushReplacement()` trong Flutter
    ///
    /// - Parameter route: Route mới
    ///
    /// # Example
    /// ```swift
    /// AppNavigation.replace(with: .home)
    /// ```
    static func replace(with route: AppRoute) {
        AppRouter.shared.replace(with: route)
    }

    /// Pop về một route cụ thể
    ///
    /// - Parameter route: Route muốn pop về
    ///
    /// # Example
    /// ```swift
    /// AppNavigation.popTo(.home)
    /// ```
    static func popTo(_ route: AppRoute) {
        AppRouter.shared.popTo(route)
    }

    // MARK: - Helpers

    /// Check xem có thể pop hay không
    static var canPop: Bool {
        return AppRouter.shared.canPop
    }

    /// Reset navigation state (dùng khi logout)
    ///
    /// # Example
    /// ```swift
    /// // Khi user logout
    /// AppNavigation.reset()
    /// AppNavigation.replace(with: .login)
    /// ```
    static func reset() {
        AppRouter.shared.reset()
    }

    // MARK: - Common Navigation Flows

    /// Navigate to login (clear stack)
    ///
    /// Dùng khi logout hoặc session expired
    ///
    /// # Example
    /// ```swift
    /// AppNavigation.navigateToLogin()
    /// ```
    static func navigateToLogin() {
        reset()
        replace(with: .login)
        AppLogger.i("📱 Navigate to login (cleared stack)")
    }

    /// Navigate to home (clear stack)
    ///
    /// Dùng sau khi login thành công
    ///
    /// # Example
    /// ```swift
    /// // After successful login
    /// AppNavigation.navigateToHome()
    /// ```
    static func navigateToHome() {
        reset()
        replace(with: .home)
        AppLogger.i("📱 Navigate to home (cleared stack)")
    }
}
