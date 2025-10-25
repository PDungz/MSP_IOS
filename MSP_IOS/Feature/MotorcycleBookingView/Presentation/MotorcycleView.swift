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

    var body: some View {
        GeometryReader { geometry in
            let safeAreaTop = geometry.safeAreaInsets.top
            let headerTopPadding = safeAreaTop + 8

            ZStack(alignment: .top) {
                // Background with two colors
                VStack(spacing: .spacing0) {
                    RoundedRectangle(cornerRadius: .radius0)
                        .foregroundStyle(
                            AppColors.grabMart.opacity(.opacity3)
                        )
                        .frame(height: min(max(geometry.size.height * 0.3, 180), 240))
                    RoundedRectangle(cornerRadius: .radius0)
                        .foregroundStyle(AppColors.bgPrimary)
                }

                VStack(spacing: .spacing0) {
                    // Header section
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
                    }
                    .padding(.top, headerTopPadding)
                    .padding(.horizontal, .padding16)

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
                    .padding(.top, .padding16)



                    // Content area
                    VStack {
                        Text("Motorcycle Booking View")
                            .font(.title2)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    let appState = AppState()
    MotorcycleBookingView(coordinator: appState.homeCoordinator)
}
