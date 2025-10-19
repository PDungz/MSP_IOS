//
//  Coordinator.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI
import Combine

// MARK: - Coordinator Protocol
protocol Coordinator: ObservableObject {
    associatedtype RouteType: Route
    var router: Router { get set }

    func navigate(to route: RouteType)
    func buildView(for route: RouteType) -> AnyView
}

// MARK: - Base Coordinator
class BaseCoordinator<RouteType: Route>: Coordinator, ObservableObject {
    var router: Router

    init(router: Router) {
        self.router = router
    }

    func navigate(to route: RouteType) {
        print("🔵 BaseCoordinator.navigate: \(route)")
        router.push(route)
    }

    func buildView(for route: RouteType) -> AnyView {
        fatalError("buildView(for:) must be implemented by subclass")
    }

    // Convenience methods
    func pop() { router.pop() }
    func popToRoot() { router.popToRoot() }
    func presentSheet(_ route: RouteType) { router.presentSheet(route) }
    func presentFullScreen(_ route: RouteType) { router.presentFullScreen(route) }
    func dismissSheet() { router.dismissSheet() }
    func dismissFullScreen() { router.dismissFullScreen() }
}

// MARK: - Coordinator View
struct CoordinatorView<C: Coordinator>: View {
    @ObservedObject var coordinator: C
    let rootRoute: C.RouteType

    @State private var navigationPath: [C.RouteType] = []

    init(coordinator: C, rootRoute: C.RouteType) {
        self.coordinator = coordinator
        self.rootRoute = rootRoute
        print("🟣 CoordinatorView.init: Created with route \(rootRoute)")
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            buildRootView()
                .navigationDestination(for: C.RouteType.self) { route in
                    buildDestinationView(for: route)
                }
        }
        .onReceive(coordinator.router.$path) { newPath in
            print("🟣 Router path changed, count: \(newPath.count)")
            syncRouterToNavigation(newPath)
        }
        .onReceive(Just(navigationPath)) { newPath in
            print("🟣 NavigationPath changed, count: \(newPath.count)")
            syncNavigationToRouter(newPath)
        }
        .sheet(item: sheetBinding) { route in
            buildSheetView(for: route)
        }
        .fullScreenCover(item: fullScreenBinding) { route in
            buildFullScreenView(for: route)
        }
        .onAppear {
            print("🟣 CoordinatorView appeared")
            syncRouterToNavigation(coordinator.router.path)
        }
    }

    // ✅ Helper methods to build views
    @ViewBuilder
    private func buildRootView() -> some View {
        coordinator.buildView(for: rootRoute)
    }

    @ViewBuilder
    private func buildDestinationView(for route: C.RouteType) -> some View {
        coordinator.buildView(for: route)
            .onAppear {
                print("🟣 NavigationStack: Building view for \(route)")
            }
    }

    @ViewBuilder
    private func buildSheetView(for route: C.RouteType) -> some View {
        coordinator.buildView(for: route)
    }

    @ViewBuilder
    private func buildFullScreenView(for route: C.RouteType) -> some View {
        coordinator.buildView(for: route)
    }

    // ✅ Sync from Router to NavigationPath
    private func syncRouterToNavigation(_ routerPath: [AnyHashable]) {
        let typed: [C.RouteType] = routerPath.compactMap { anyHashable in
            if let route = anyHashable.base as? C.RouteType {
                return route
            }

            let mirror = Mirror(reflecting: anyHashable)
            for child in mirror.children {
                if let route = child.value as? C.RouteType {
                    return route
                }
            }

            return nil
        }

        print("🟣 Extracted routes: \(typed)")

        if navigationPath != typed {
            navigationPath = typed
            print("🟣 Updated navigationPath to: \(typed)")
        }
    }

    // ✅ Sync from NavigationPath to Router (when user taps back button)
    private func syncNavigationToRouter(_ navPath: [C.RouteType]) {
        let routerTyped: [C.RouteType] = coordinator.router.path.compactMap { anyHashable in
            if let route = anyHashable.base as? C.RouteType {
                return route
            }

            let mirror = Mirror(reflecting: anyHashable)
            for child in mirror.children {
                if let route = child.value as? C.RouteType {
                    return route
                }
            }

            return nil
        }

        if navPath != routerTyped {
            print("🟣 Syncing navigationPath back to router")
            coordinator.router.path = navPath.map { AnyHashable($0) }
        }
    }

    private var sheetBinding: Binding<C.RouteType?> {
        Binding(
            get: {
                guard let sheet = coordinator.router.presentedSheet else { return nil }
                return sheet.base as? C.RouteType
            },
            set: { _ in coordinator.router.dismissSheet() }
        )
    }

    private var fullScreenBinding: Binding<C.RouteType?> {
        Binding(
            get: {
                guard let fullScreen = coordinator.router.presentedFullScreen else { return nil }
                return fullScreen.base as? C.RouteType
            },
            set: { _ in coordinator.router.dismissFullScreen() }
        )
    }
}
