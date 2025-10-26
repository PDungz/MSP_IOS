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
    @State private var isRefreshing: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let safeAreaTop = geometry.safeAreaInsets.top
            let headerTopPadding = safeAreaTop + 8

            // Tính toán stretch offset
            let stretchOffset = max(0, -scrollOffset)

            ScrollView {
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

                        // Normal content
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

                        // Spacer để tạo stretch space
                        if stretchOffset > 0 {
                            Spacer()
                                .frame(height: stretchOffset)
                        }
                    }
                    .padding(.top, headerTopPadding)
                    .padding(.horizontal, .padding16)
                    .padding(.bottom, .padding42)
                    .frame(maxWidth: .infinity)
                    .background(
                        GeometryReader { headerGeo in
                            AppColors.grabMart.opacity(.opacity3)
                                .frame(
                                    width: headerGeo.size.width,
                                    height: max(
                                        headerGeo.size.height + safeAreaTop + stretchOffset, 800
                                    )
                                )
                                .offset(
                                    y: min(
                                        -safeAreaTop - stretchOffset, -500
                                    )
                                )
                        }
                    )
                    .overlay(
                        isRefreshing ?
                        GeometryReader { headerGeo in
                            ZStack {
                                Color.clear
                                    .background(.ultraThinMaterial)

                                LoadingDotsView()

                            }
                            .frame(
                                width: headerGeo.size.width,
                                height: max(
                                    headerGeo.size.height + safeAreaTop, 800
                                )
                            )
                            .offset(
                                y: min(
                                    -safeAreaTop, -500
                                )
                            )
                        } : nil
                    )


                    // Content area
                    VStack(spacing: .spacing0) {
                        // TextField with negative offset to overlap the header
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
                                        backgroundColor: AppColors.gray300
                                            .opacity(.opacity3),
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
                        .padding(.horizontal, .padding16)
                        .offset(y: -.padding32)

                        // Main content
                        HistoryLocation()

                        Spacer()
                    }
                    .background(AppColors.bgPrimary)
                }
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                scrollOffset = value

                // Bật isRefreshing khi user kéo xuống đủ xa
                let stretchOffset = max(0, -scrollOffset)
                if stretchOffset > 60 && !isRefreshing {
                    isRefreshing = true
                }
            }
            .refreshable {
                await performRefresh()
            }
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.all, edges: .top)
        }
    }

    private func performRefresh() async {
        print("🔄 Refreshing started...")
        isRefreshing = true

        // ✅ Dùng withCheckedContinuation - không thể cancel
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("⏰ Sleep finished")
                continuation.resume()
            }
        }

        isRefreshing = false
        print("✅ Refresh done")
    }
}



// MARK: - ScrollOffset PreferenceKey
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
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
