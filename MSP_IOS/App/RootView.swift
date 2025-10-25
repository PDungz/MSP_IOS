//
//  RootView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState
    @State private var navigationPath: [HomeRoute] = []

    var body: some View {
        Group {
            if appState.isAuthenticated {
                // NavigationStack ở cấp cao nhất để có thể navigate full screen
                NavigationStack(path: $navigationPath) {
                    MainTabView(router: appState.router, appState: appState)
                        .navigationDestination(for: HomeRoute.self) { route in
                            appState.homeCoordinator.buildView(for: route)
                        }
                }
                .onReceive(appState.router.$path) { newPath in
                    syncRouterToNavigation(newPath)
                }
                .onChange(of: navigationPath) { newValue in
                    syncNavigationToRouter(newValue)
                }
            } else {
                CoordinatorView(
                    coordinator: appState.authCoordinator,
                    rootRoute: .login
                )
            }
        }
        .animation(.easeInOut, value: appState.isAuthenticated)
        .backgroundStyle(AppColors.bgPrimary)
    }

    // Sync Router path to NavigationStack
    private func syncRouterToNavigation(_ routerPath: [AnyHashable]) {
        let typed: [HomeRoute] = routerPath.compactMap { anyHashable in
            if let route = anyHashable.base as? HomeRoute {
                return route
            }
            return nil
        }

        if navigationPath != typed {
            navigationPath = typed
        }
    }

    // Sync NavigationStack back to Router (when user taps back button)
    private func syncNavigationToRouter(_ navPath: [HomeRoute]) {
        let routerTyped: [HomeRoute] = appState.router.path.compactMap { anyHashable in
            if let route = anyHashable.base as? HomeRoute {
                return route
            }
            return nil
        }

        if navPath != routerTyped {
            appState.router.path = navPath.map { AnyHashable($0) }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
