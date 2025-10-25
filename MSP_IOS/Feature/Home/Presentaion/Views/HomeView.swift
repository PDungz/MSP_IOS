//
//  HomeView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 16/10/25.
//

import SwiftUI

struct HomeView: View {

    let coordinator: HomeCoordinator
    @ObservedObject var appState: AppState
    @State private var searchText: String = ""

    var body: some View {
        VStack {
            HStack{
                CircleButtonView(
                    icon: .system("qrcode.viewfinder"),
                    backgroundColor: AppColors.bgPrimary.opacity(.opacity3),
                    size: .iconSize42
                ) {
                    print("QR Code tapped")
                }

                TextFieldView(
                    text: $searchText,
                    placeholder: NSLocalizedString("home_search1", comment: "Search placeholder"),
                    animatedPlaceholders: [
                        NSLocalizedString("home_search1", comment: "Search placeholder"),
                        NSLocalizedString("home_search2", comment: "Search placeholder"),
                    ],
                    leftIcon: .system("magnifyingglass"),
                    showClearButton: false,
                    keyboardType: .default,
                    verticalPadding: .padding10,
                    isAnimatedPlaceholder: true,
                    backgroundColor: AppColors.white,
                    shadowColor: .clear
                )

                CircleButtonView(
                    icon: .system("person.fill"),
                    backgroundColor: AppColors.bgPrimary.opacity(.opacity4),
                    size: .iconSize42
                ) {
                    print("Profile tapped")
                }
            }
            .padding(.horizontal)
            .padding(.top, .padding8)
            .padding(.bottom, .padding12)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            AppColors.grabGreen,
                            AppColors.grabGreenLight
                        ]
                    ),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )

            CategoryView(coordinator: coordinator)

            Spacer()
        }
    }
}

#Preview {
    let router = Router()
    let appState = AppState()
    let coordinator = HomeCoordinator(router: router, appState: appState)

    return HomeView(coordinator: coordinator, appState: appState)
}
