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

    // Threshold để trigger refresh (kéo xuống bao nhiêu pixel)
    private let refreshThreshold: CGFloat = 80

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
                                                -safeAreaTop - stretchOffset, -500
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
                .background(GeometryReader{
                    self.detecScrollOffset(grometry: $0)
                })
            }
            .coordinateSpace(name: "Scrollview")
            .navigationBarBackButtonHidden(true)
            .ignoresSafeArea(.all, edges: .top)
        }
    }



    func detecScrollOffset(grometry: GeometryProxy) -> some View {
        let yOffset = grometry.frame(in: .named("Scrollview")).minY

        DispatchQueue.main.async {
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
        // Simulate API call or reload data
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Reset refresh state after completion
            self.isRefreshing = false
            print("Data refreshed successfully!")
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
