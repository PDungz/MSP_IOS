//
//  HomeCoordinator.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 23/10/25.
//

import SwiftUI

final class HomeCoordinator: BaseCoordinator<HomeRoute> {

    let appState: AppState

    init(router: Router, appState: AppState) {
        self.appState = appState
        super.init(router: router)
    }

    override func buildView(for route: HomeRoute) -> AnyView {
        switch route {
        case .home:
            return AnyView(HomeView(coordinator: self, appState: appState))

        case .motorcycleBooking:
            return AnyView(MotorcycleBookingView(coordinator: self))

        case .carBooking:
            return AnyView(CarBookingView())

        case .foodOrder:
            return AnyView(FoodOrderView())

        case .shipping:
            return AnyView(ShippingView())

        case .shopping:
            return AnyView(ShoppingView())

        case .voucher:
            return AnyView(VoucherView())

        case .bookDriver:
            return AnyView(BookDriverView())

        case .allCategories:
            return AnyView(AllCategoriesView())
        }
    }

    // MARK: - Navigation Methods
    func navigateToCategory(_ category: Category) {
        print("🔵 HomeCoordinator: Navigate to category \(category.title)")
        let route = categoryToRoute(category)

        // Special case: Show bottom sheet for "All Categories"
        if category == .all {
            presentSheet(route)
        } else {
            navigate(to: route)
        }
    }

    func backToHome() {
        print("🔵 HomeCoordinator: Back to Home")
        pop()
    }

    // Helper: Convert Category to HomeRoute
    private func categoryToRoute(_ category: Category) -> HomeRoute {
        switch category {
        case .motorcycle:
            return .motorcycleBooking
        case .car:
            return .carBooking
        case .food:
            return .foodOrder
        case .shipping:
            return .shipping
        case .shopping:
            return .shopping
        case .voucher:
            return .voucher
        case .bookDriver:
            return .bookDriver
        case .all:
            return .allCategories
        }
    }
}
