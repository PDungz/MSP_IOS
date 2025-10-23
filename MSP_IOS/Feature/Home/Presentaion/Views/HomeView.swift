//
//  HomeView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 16/10/25.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var router: Router
    @ObservedObject var appState: AppState

    var body: some View {
        VStack {
            HStack{
                CircleButtonView(
                    icon: .system("qrcode.viewfinder"),
                    backgroundColor: AppColors.bgPrimary
                    .opacity(.opacity3),
                    size: .iconSize42) {
                    print("Small")
                }
                TextFieldView(
                    animatedPlaceholders: [
                        NSLocalizedString("home_search1", comment: "Search placeholder"),
                        NSLocalizedString("home_search2", comment: "Search placeholder"),
                    ],
                    iconName: "magnifyingglass",
                    showClearButton: false,
                    keyboardType: .emailAddress,
                    verticalPadding: .padding10,
                    isAnimatedPlaceholder: true
                )

                CircleButtonView(
                    icon: .system("person.fill"),
                    backgroundColor: AppColors.bgPrimary
                    .opacity(.opacity4),
                    size: .iconSize42)  {
                    print("Small")

                }
            }
            .padding(.horizontal)
            .padding(.top, .padding8)
            .padding(.bottom, .padding12)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            AppColors.primaryGreenLight,
                            AppColors.primaryGreenLight.opacity(.opacity8)
                        ]
                    ),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )

            CategoryView()

            Spacer()
        }
    }
}

#Preview {
    HomeView(router: Router(), appState: AppState())
}
