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
                    HomeView(router: router, appState: appState)
                case .payment:
                    PaymentView()
                case .message:
                    MessageView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom Tab Bar
            TabBarView(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    MainTabView(router: Router(), appState: AppState())
}
