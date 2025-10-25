//
//  MainTabView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 21/10/25.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var router: Router
    @ObservedObject var appState: AppState
    @State private var selectedTab: TabItem = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            Group {
                switch selectedTab {
                case .home:
                    HomeView(coordinator: appState.homeCoordinator, appState: appState)
                case .payment:
                    PaymentView()
                case .activity:
                    ActionView()
                case .message:
                    MessageView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom Tab Bar
            TabBarView(selectedTab: $selectedTab)
        }
        .sheet(item: sheetBinding) { route in
            appState.homeCoordinator.buildView(for: route)
                .environmentObject(appState)
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .edgesIgnoringSafeArea(.bottom)
        .onChange(of: selectedTab) { newTab in
            // Clear sheet khi chuyển tab
            if router.presentedSheet != nil {
                router.dismissSheet()
            }
        }
    }

    // Binding for sheet presentation
    private var sheetBinding: Binding<HomeRoute?> {
        Binding(
            get: {
                guard let sheet = router.presentedSheet else { return nil }
                return sheet.base as? HomeRoute
            },
            set: { _ in router.dismissSheet() }
        )
    }
}

#Preview {
    MainTabView(router: Router(), appState: AppState())
}
