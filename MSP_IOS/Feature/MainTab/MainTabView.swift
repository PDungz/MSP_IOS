//
//  MainTabView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 21/10/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
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
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    MainTabView()
}
