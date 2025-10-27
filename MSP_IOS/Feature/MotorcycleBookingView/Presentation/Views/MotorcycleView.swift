//
//  MotorcycleView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 24/10/25.
//

import SwiftUI

struct MotorcycleBookingView: View {
    let coordinator: HomeCoordinator
    @State private var locationString: String = ""
    @State private var scrollOffset: CGFloat = 0
    @State private var previousScrollOffset: CGFloat = 0
    @State private var isRefreshing: Bool = false
    @State private var showHeader: Bool = true
    @State private var headerHeight: CGFloat = 0

    // Threshold để trigger refresh (kéo xuống bao nhiêu pixel)
    private let refreshThreshold: CGFloat = .spacing64
    // Threshold để detect scroll direction
    private let scrollThreshold: CGFloat = .spacing96

    var body: some View {
        GeometryReader { geometry in
            let safeAreaTop = geometry.safeAreaInsets.top
            let headerTopPadding = safeAreaTop + 8

            // Tính toán stretch offset
            let stretchOffset = max(0, -scrollOffset)

            ScrollView (showsIndicators: false){
                VStack(spacing: .spacing0) {
                    // Header section với stretch effect
                    VStack(spacing: .spacing8) {
                        HStack {
                            ButtonView(
                                config: ButtonConfig(
                                    style: .text,
                                    fitContent: true,
                                    cornerRadius: .radius32,
                                    foregroundColor: .textPrimary,
                                    horizontalPadding: .padding8,
                                    verticalPadding: .padding0
                                )
                            ) {
                                coordinator.backToHome()
                            } content: {
                                HStack(spacing: .spacing12) {
                                    Image(systemName: "arrow.left")
                                        .font(.title2)
                                    Text("Di Chuyển")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                .foregroundStyle(AppColors.textPrimary)
                            }

                            Spacer()

                            ButtonView(
                                title: "Bản đồ",
                                icon: .system("map"),
                                config: ButtonConfig(
                                    style: .primary,
                                    fitContent: true,
                                    cornerRadius: .radius32,
                                    backgroundColor: AppColors.gray300.opacity(.opacity3),
                                    foregroundColor: .primary,
                                    verticalPadding: .padding8
                                )
                            ) {
                                coordinator.backToHome()
                            }
                        }

                        // Normal content with animation

                        VStack(alignment: .leading, spacing: .spacing0) {
                            Text("Ngày quan trọng của bạn? Đặt xe trước, luôn đúng giờ!")
                                .padding(.trailing, .padding64 * 2)
                                .font(.subheadline)

                            ButtonView(
                                config: ButtonConfig(
                                    style: .text,
                                    fitContent: true,
                                    cornerRadius: .radius20,
                                    horizontalPadding: .padding0,
                                    verticalPadding: .padding2
                                )
                            ) {
                                print("Premium")
                            } content: {
                                HStack(spacing: .spacing4) {
                                    Text("Đặt liền tay, giảm 10%")
                                        .fontWeight(.bold)
                                    Image(systemName: "arrow.forward.circle.fill")
                                }
                                .font(.subheadline)
                                .foregroundStyle(AppColors.textPrimary)
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))


                        // Spacer để tạo stretch space
                        if showHeader && stretchOffset > 0 {
                            Spacer()
                                .frame(height: stretchOffset - .spacing84)
                        }
                    }
                    .padding(.top, headerTopPadding)
                    .padding(.horizontal, .padding16)
                    .padding(.bottom, showHeader ? .padding42 : .padding12)
                    .frame(maxWidth: .infinity)
                    .background(
                        GeometryReader { headerGeo in
                            AppColors.grabMart.opacity(.opacity3)
                                .frame(
                                    width: headerGeo.size.width,
                                    height: max(
                                        headerGeo.size.height + safeAreaTop + stretchOffset, 600
                                    )
                                )
                                .offset(
                                    y: min(
                                        -safeAreaTop - stretchOffset, -300
                                    )
                                )
                                .onAppear {
                                    // Capture header height
                                    DispatchQueue.main.async {
                                        self.headerHeight = headerGeo.size.height
                                    }
                                }
                        }
                    )
                    .overlay(alignment: .center) {
                        if isRefreshing {
                            ZStack {
                                // Background blur
                                GeometryReader { headerGeo in
                                    Color.clear
                                        .background(.ultraThinMaterial)
                                        .frame(
                                            width: headerGeo.size.width,
                                            height: max(
                                                headerGeo.size.height + safeAreaTop + stretchOffset, 800
                                            )
                                        )
                                        .offset(
                                            y: min(
                                                -safeAreaTop - stretchOffset, -300
                                            )
                                        )
                                }

                                // Loading indicator always centered
                                LoadingDotsView()
                            }
                        }
                    }

                    // Content area
                    VStack(spacing: .spacing0) {
                        // TextField with negative offset to overlap the header
                        !showHeader ? nil :
                        TextFieldView(
                            text: $locationString,
                            placeholder: "Bạn muốn đến đâu?",
                            leftIcon: .asset("pin"),
                            rightIcon: .custom(
                                ButtonView(
                                    title: "Hẹn",
                                    icon: .system("calendar"),
                                    config: ButtonConfig(
                                        style: .primary,
                                        fitContent: true,
                                        cornerRadius: .radius16,
                                        backgroundColor: AppColors.grabGreen
                                            .opacity(.opacity05),
                                        foregroundColor: .primary,
                                        verticalPadding: .padding6
                                    )
                                ) {}
                            ),
                            isInteractive: false,
                            verticalPadding: .padding12,
                            iconColor: AppColors.rating1Star,
                            onTap: {
                                print("Bạn muốn đến đâu?")
                            }
                        )
                        .padding(.horizontal, .padding20)
                        .offset(y: showHeader ? -.padding32 : -.padding12)
                        .animation(.easeInOut(duration: 0.3), value: showHeader)

                        // Main content
                        HistoryLocation()
                            .padding(.bottom, .padding20)

                        RideWithDiscountView()
                            .padding(.bottom, .padding20)

                        RideWithDiscountView()
                            .padding(.bottom, .padding20)

                        RideWithDiscountView()
                            .padding(.bottom, .padding20)

                        Spacer()
                    }
                    .background(AppColors.bgPrimary)
                }
                .background(GeometryReader{
                    self.detecScrollOffset(grometry: $0)
                }
                )
            }
            .coordinateSpace(name: "Scrollview")
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.all, edges: .top)
            .safeAreaInset(edge: .top, spacing: 0) {
               if !showHeader {
                   HStack {
                       ButtonView(
                           config: ButtonConfig(
                               style: .text,
                               fitContent: true,
                               cornerRadius: .radius32,
                               foregroundColor: .textPrimary,
                               horizontalPadding: .padding8,
                               verticalPadding: .padding0
                           )
                       ) {
                           coordinator.backToHome()
                       } content: {
                           HStack(spacing: .spacing12) {
                               Image(systemName: "arrow.left")
                                   .font(.title3)
                           }
                           .foregroundStyle(AppColors.textPrimary)
                       }
                       TextFieldView(
                        text: $locationString,
                        placeholder: "Bạn muốn đến đâu?",
                        leftIcon: .asset("pin"),
                        isInteractive: false,
                        verticalPadding: .padding12,
                        iconColor: AppColors.rating1Star,
                        onTap: {
                            print("Bạn muốn đến đâu?")
                        }
                       )


                       ButtonView(
                           title: "Hẹn",
                           icon: .system("calendar"),
                           config: ButtonConfig(
                               style: .primary,
                               fitContent: true,
                               cornerRadius: .radius16,
                               backgroundColor: AppColors.grabGreen
                                   .opacity(.opacity05),
                               foregroundColor: .primary,
                               verticalPadding: .padding8
                           )
                       ) {}
                   }
                   .padding(.horizontal, .padding20)
                   .padding(.vertical, .padding8)
                   .background(AppColors.bgPrimary)
                }
            }
        }
    }



    func detecScrollOffset(grometry: GeometryProxy) -> some View {
        let yOffset = grometry.frame(in: .named("Scrollview")).minY

        DispatchQueue.main.async {
            // Detect scroll direction
            let scrollDelta = yOffset - self.previousScrollOffset

            // Only update if scroll delta exceeds threshold (to avoid jitter)
            if abs(scrollDelta) > scrollThreshold {
                // Scrolling up (yOffset becomes more negative)
                if scrollDelta < 0 && yOffset < -20 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.showHeader = false
                    }
                }
                // Scrolling down (yOffset becomes less negative or positive)
                else if scrollDelta > 0 && yOffset > -100 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        self.showHeader = true
                    }
                }

                self.previousScrollOffset = yOffset
            }

            self.scrollOffset = yOffset

            // Detect pull down to refresh
            if yOffset > refreshThreshold && !isRefreshing {
                self.isRefreshing = true
                self.performRefresh()
            }
        }
        return Rectangle().fill(Color.clear)
    }

    // Perform refresh action
    private func performRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isRefreshing = false
        }
    }
}

// MARK: - Loading Dots View
struct LoadingDotsView: View {
    @State private var scale1: CGFloat = 0.8
    @State private var scale2: CGFloat = 0.8
    @State private var scale3: CGFloat = 0.8

    var body: some View {
        HStack(alignment: .center, spacing: .spacing12) {
            Circle()
                .fill(AppColors.bgPrimary)
                .frame(width: .spacing8, height: .spacing8)
                .scaleEffect(scale1)
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 0.6).repeatForever()
                    ) {
                        scale1 = 1.2
                    }
                }

            Circle()
                .fill(AppColors.bgPrimary)
                .frame(width: .spacing8, height: .spacing8)
                .scaleEffect(scale2)
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 0.6).repeatForever().delay(0.2)
                    ) {
                        scale2 = 1.2
                    }
                }

            Circle()
                .fill(AppColors.bgPrimary)
                .frame(width: .spacing8, height: .spacing8)
                .scaleEffect(scale3)
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 0.6).repeatForever().delay(0.4)
                    ) {
                        scale3 = 1.2
                    }
                }
        }
    }
}

#Preview {
    let appState = AppState()
    MotorcycleBookingView(coordinator: appState.homeCoordinator)
}
