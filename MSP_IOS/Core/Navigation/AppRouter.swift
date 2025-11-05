//
//  AppRouter.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 05/11/25.
//  Centralized Navigation Manager
//

import SwiftUI

/// Singleton quản lý navigation trong toàn app
///
/// # Overview
/// AppRouter quản lý NavigationPath và cung cấp centralized navigation control.
/// Tương tự GoRouter trong Flutter.
///
/// # Usage
/// ```swift
/// // Access singleton
/// let router = AppRouter.shared
///
/// // Navigate
/// router.push(.home)
/// router.pop()
/// ```
///
/// - Important: Singleton này được observe bởi root NavigationStack
/// - Note: ObservableObject để SwiftUI tự động update UI khi navigation thay đổi
class AppRouter: ObservableObject {
    /// Singleton instance
    static let shared = AppRouter()

    /// Navigation path - quản lý navigation stack
    @Published var path = NavigationPath()

    /// Current route (for debugging)
    @Published var currentRoute: AppRoute?

    /// Private initializer để ensure singleton
    private init() {
        AppLogger.i("AppRouter initialized")
    }

    // MARK: - Navigation Methods

    /// Push một route lên navigation stack
    ///
    /// Tương tự: `context.push()` trong Flutter
    ///
    /// - Parameter route: Route muốn navigate tới
    ///
    /// # Example
    /// ```swift
    /// AppRouter.shared.push(.home)
    /// AppRouter.shared.push(.userDetail(userId: "123"))
    /// ```
    func push(_ route: AppRoute) {
        path.append(route)
        currentRoute = route
        AppLogger.i("📱 Navigate to: \(route.title)")
    }

    /// Pop back một màn hình
    ///
    /// Tương tự: `context.pop()` trong Flutter
    ///
    /// # Example
    /// ```swift
    /// AppRouter.shared.pop()
    /// ```
    func pop() {
        if !path.isEmpty {
            path.removeLast()
            AppLogger.i("📱 Pop back")
        }
    }

    /// Pop về root (clear toàn bộ stack)
    ///
    /// Tương tự: `context.go()` trong Flutter
    ///
    /// # Example
    /// ```swift
    /// AppRouter.shared.popToRoot()
    /// ```
    func popToRoot() {
        path.removeLast(path.count)
        currentRoute = nil
        AppLogger.i("📱 Pop to root")
    }

    /// Replace current route với route mới
    ///
    /// Tương tự: `context.pushReplacement()` trong Flutter
    ///
    /// - Parameter route: Route mới
    ///
    /// # Example
    /// ```swift
    /// AppRouter.shared.replace(with: .home)
    /// ```
    func replace(with route: AppRoute) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
        currentRoute = route
        AppLogger.i("📱 Replace with: \(route.title)")
    }

    /// Pop về một route cụ thể
    ///
    /// - Parameter route: Route muốn pop về
    func popTo(_ route: AppRoute) {
        // Note: NavigationPath không support direct access
        // Workaround: Pop all và push lại route
        popToRoot()
        push(route)
        AppLogger.i("📱 Pop to: \(route.title)")
    }

    /// Check xem có thể pop hay không
    var canPop: Bool {
        return !path.isEmpty
    }

    /// Reset navigation state (dùng khi logout)
    func reset() {
        path = NavigationPath()
        currentRoute = nil
        AppLogger.i("📱 Navigation reset")
    }
}
