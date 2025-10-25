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
        ZStack {
            VStack {
                VStack(spacing: .spacing0){
                    RoundedRectangle(cornerRadius: .radius0)
                        .foregroundStyle(
                            AppColors.grabMart.opacity(.opacity3)
                        )
                        .frame(height: 212)
                    RoundedRectangle(cornerRadius: .radius0)
                        .foregroundStyle(AppColors.bgPrimary)
                        .frame(height: .infinity)
                }
            }
            VStack {
                VStack {
                    HStack {
                        ButtonView(
                            config: ButtonConfig(
                                style: .text,
                                fitContent: true,
                                cornerRadius: .radius32,
                                foregroundColor: .textPrimary,
                                horizontalPadding: .padding0,
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
                    .padding(.top, 56)
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
                                verticalPadding: .padding4
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
                Spacer()
                Text("Motorcycle Booking View")
                    .font(.title2)
                Spacer()
            }
            .padding(.horizontal, .padding16)
        }
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    let appState = AppState()
    MotorcycleBookingView(coordinator: appState.homeCoordinator)
}
