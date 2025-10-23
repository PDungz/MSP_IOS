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
        NavigationView {
            ZStack(alignment: .bottom) {
                // Content
                Group {
                    switch selectedTab {
                    case .home:
                        HomeView(router: router, appState: appState)
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
            .navigationBarHidden(true)
            .ignoresSafeArea(.keyboard)
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MainTabView(router: Router(), appState: AppState())
}
