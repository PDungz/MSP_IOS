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
            // Use actual LoginView from Auth feature
            MSP_IOS.LoginView()

        case .register:
            SignUpView()

        case .forgotPassword:
            ForgotPasswordView()

        // MARK: - Main App Routes
        case .home:
            // Use MainTabView which contains HomeView
            MainTabView()

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
            // Use actual MotorcycleBookingView from MotorcycleBookingView feature
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

// MARK: - Placeholder Views (Replace with actual views when available)

/// User Detail View (Placeholder - replace when actual view is ready)
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
