//
//  RootView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.isAuthenticated {
                HomeView(router: appState.router, appState: appState)
            } else {
                CoordinatorView(
                    coordinator: appState.authCoordinator,
                    rootRoute: .login
                )
            }
        }
        .animation(.easeInOut, value: appState.isAuthenticated)
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
