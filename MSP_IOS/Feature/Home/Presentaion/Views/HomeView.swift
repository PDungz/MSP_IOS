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
    @State private var scrollOffset: CGFloat = 0
    @State private var previousScrollOffset: CGFloat = 0
    @State private var isRefreshing: Bool = false
    @State private var showHeader: Bool = true

    // Threshold để trigger refresh
    private let refreshThreshold: CGFloat = .spacing64
    // Giới hạn chiều cao khi kéo xuống
    private let maxStretchOffset: CGFloat = .spacing128
    // Threshold để detect scroll direction
    private let scrollThreshold: CGFloat = .spacing0

    var body: some View {
        GeometryReader { geometry in
            let safeAreaTop = geometry.safeAreaInsets.top
            let headerTopPadding = safeAreaTop + 8

            // Tính toán stretch offset với giới hạn
            let stretchOffset = min(max(0, -scrollOffset), maxStretchOffset)

            ScrollView(showsIndicators: false) {
                VStack(spacing: .spacing0) {
                    // Header section với stretch effect
                    VStack(spacing: .spacing8) {
                        if isRefreshing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: AppColors.white))
                                .scaleEffect(1.5)
                                .padding(.bottom, .padding12)
                        }
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
                    }
                    .padding(.top, headerTopPadding)
                    .padding(.horizontal, .padding16)
                    .padding(.bottom, showHeader ? .padding12 : .padding8)
                    .frame(maxWidth: .infinity)
                    .background(
                        GeometryReader { headerGeo in
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        AppColors.grabGreen.opacity(.opacity6),
                                        AppColors.grabGreenLight,
                                    ]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .frame(
                                width: headerGeo.size.width,
                                height: max(headerGeo.size.height + safeAreaTop + stretchOffset, 600)
                            )
                            .offset(y: min(-safeAreaTop - stretchOffset, -300))
                        }
                    )
                    // Content area
                    VStack(spacing: .spacing0) {
                        HomeCategoryView(coordinator: coordinator)
                            .padding(.bottom, .padding12)

                        AddCardAndGrabRewardsView()
                            .padding(.horizontal)
                            .padding(.bottom, .padding24)

                        HomeBannerAdView()
                            .padding(.bottom, .padding24)

                        HomeListItemOrderView(headerTitle: "Có thể bạn sẽ thích")
                            .padding(.bottom, .padding24)

                        HomeListItemOrderView(headerTitle: "Được yêu thích")
                            .padding(.bottom, .padding12)
                    }
                    .background(AppColors.bgPrimary)
                }
                .background(GeometryReader {
                    self.detectScrollOffset(geometry: $0)
                })
            }
            .coordinateSpace(name: "ScrollView")
            .safeAreaInset(edge: .top, spacing: 0) {
                !showHeader ?
                RoundedRectangle(cornerRadius: .padding0)
                .fill(AppColors.bgPrimary)
                .frame(height: headerTopPadding) : nil
            }
            .ignoresSafeArea(.all, edges: .top)
        }
    }

    func detectScrollOffset(geometry: GeometryProxy) -> some View {
        let yOffset = geometry.frame(in: .named("ScrollView")).minY

        DispatchQueue.main.async {
            self.scrollOffset = yOffset

            let scrollDelta = yOffset - self.previousScrollOffset

            // Only update if scroll delta exceeds threshold (to avoid jitter)
            if abs(scrollDelta) > scrollThreshold {
                // Scrolling up (yOffset becomes more negative)
                if scrollDelta < 0 && yOffset < -20 {
                    self.showHeader = false
                }
                // Scrolling down (yOffset becomes less negative or positive)
                else if scrollDelta > 0 && yOffset > -100 {
                    self.showHeader = true
                }

                self.previousScrollOffset = yOffset
            }

            // Detect pull down to refresh
            if yOffset > refreshThreshold && !isRefreshing {
                self.isRefreshing = true
                self.performRefresh()
            }
        }
        return Color.clear
    }

    // Perform refresh action
    private func performRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isRefreshing = false
        }
    }
}

#Preview {
    let router = Router()
    let appState = AppState()
    let coordinator = HomeCoordinator(router: router, appState: appState)

    HomeView(coordinator: coordinator, appState: appState)
}
