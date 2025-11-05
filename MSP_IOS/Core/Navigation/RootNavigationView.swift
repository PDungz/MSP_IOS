//
//  RootNavigationView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 05/11/25.
//  Root Navigation Container
//

import SwiftUI

/// Root navigation container cho toàn app
///
/// # Overview
/// View này setup NavigationStack với AppRouter và handle destination resolution.
/// Tương tự MaterialApp với GoRouter trong Flutter.
///
/// # Usage
/// ```swift
/// @main
/// struct MSP_IOSApp: App {
///     var body: some Scene {
///         WindowGroup {
///             RootNavigationView(initialRoute: .login)
///         }
///     }
/// }
/// ```
///
/// - Important: Phải dùng view này làm root của app
struct RootNavigationView: View {
    @StateObject private var router = AppRouter.shared
    let initialRoute: AppRoute

    init(initialRoute: AppRoute = .login) {
        self.initialRoute = initialRoute
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            // Initial/Root view
            destinationView(for: initialRoute)
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .environmentObject(router)
    }

    // MARK: - Destination Resolver

    /// Resolve route thành View tương ứng
    ///
    /// Tương tự route builder trong GoRouter
    ///
    /// - Parameter route: AppRoute case
    /// - Returns: View tương ứng
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        // MARK: - Auth Routes
        case .login:
            LoginView()

        case .register:
            Text("Register Screen")
                .navigationTitle(route.title)

        case .forgotPassword:
            Text("Forgot Password Screen")
                .navigationTitle(route.title)

        // MARK: - Main App Routes
        case .home:
            HomeView()

        case .profile:
            Text("Profile Screen")
                .navigationTitle(route.title)

        case .settings:
            Text("Settings Screen")
                .navigationTitle(route.title)

        // MARK: - User Routes
        case .userList:
            Text("User List Screen")
                .navigationTitle(route.title)

        case .userDetail(let userId):
            UserDetailView(userId: userId)

        case .userEdit(let userId):
            Text("User Edit Screen: \(userId)")
                .navigationTitle(route.title)

        // MARK: - Motorcycle Booking Routes
        case .motorcycleBooking:
            MotorcycleBookingView()

        case .motorcycleDetail(let motorcycleId):
            Text("Motorcycle Detail: \(motorcycleId)")
                .navigationTitle(route.title)

        case .bookingConfirm:
            Text("Booking Confirm Screen")
                .navigationTitle(route.title)

        case .bookingHistory:
            Text("Booking History Screen")
                .navigationTitle(route.title)

        // MARK: - Order/Food Routes
        case .foodList:
            Text("Food List Screen")
                .navigationTitle(route.title)

        case .foodDetail(let foodId):
            Text("Food Detail: \(foodId)")
                .navigationTitle(route.title)

        case .cart:
            Text("Cart Screen")
                .navigationTitle(route.title)

        case .orderConfirm:
            Text("Order Confirm Screen")
                .navigationTitle(route.title)

        case .orderHistory:
            Text("Order History Screen")
                .navigationTitle(route.title)

        // MARK: - Other Routes
        case .notifications:
            Text("Notifications Screen")
                .navigationTitle(route.title)

        case .help:
            Text("Help Screen")
                .navigationTitle(route.title)

        case .about:
            Text("About Screen")
                .navigationTitle(route.title)
        }
    }
}

// MARK: - Placeholder Views (Replace với actual views)

/// User Detail View
private struct UserDetailView: View {
    let userId: String

    var body: some View {
        VStack(spacing: 20) {
            Text("User Detail")
                .font(.title)

            Text("User ID: \(userId)")
                .font(.subheadline)

            Button("Edit User") {
                AppNavigation.push(.userEdit(userId: userId))
            }

            Button("Back") {
                AppNavigation.pop()
            }
        }
        .navigationTitle("User Detail")
    }
}

/// Login View (Replace với actual LoginView từ Auth feature)
private struct LoginView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Login Screen")
                .font(.title)

            Button("Go to Register") {
                AppNavigation.navigateToRegister()
            }

            Button("Go to Home (Mock Login)") {
                AppNavigation.navigateToHome()
            }
        }
        .navigationTitle("Đăng nhập")
    }
}

/// Home View (Replace với actual HomeView từ Home feature)
private struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Home Screen")
                .font(.title)

            Button("Go to Profile") {
                AppNavigation.navigateToProfile()
            }

            Button("Go to Motorcycle Booking") {
                AppNavigation.navigateToMotorcycleBooking()
            }

            Button("Go to User List") {
                AppNavigation.navigateToUserList()
            }

            Button("Logout") {
                AppNavigation.navigateToLogin()
            }
        }
        .navigationTitle("Trang chủ")
    }
}

/// Motorcycle Booking View (Replace với actual view)
private struct MotorcycleBookingView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Motorcycle Booking")
                .font(.title)

            Button("View Motorcycle Detail") {
                AppNavigation.navigateToMotorcycleDetail(motorcycleId: "123")
            }

            Button("Back") {
                AppNavigation.pop()
            }
        }
        .navigationTitle("Đặt xe")
    }
}
