//
//  BookDriverView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 31/10/25.
//

import SwiftUI
import MapKit

struct BookDriverView: View {
    @StateObject private var viewModel = BookDriverViewModel()

    var body: some View {
        ZStack {
            MapView(
                region: $viewModel.mapConfig.region,
                mapType: viewModel.mapConfig.mapType,
                showRoute: viewModel.mapConfig.showRoute,
                is3DMode: viewModel.mapConfig.is3DMode,
                startCoordinate: viewModel.booking.startLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 21.0285, longitude: 105.8542),
                endCoordinate: viewModel.booking.endLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 21.0385, longitude: 105.8642)
            )

            VStack {
                HStack{
                    CircleButtonView(
                        icon: .system("arrow.left"),
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.textPrimary,
                        size: .iconSize42
                    ) {
                        // Back action
                    }

                    Spacer()

                    ButtonView(
                        config: ButtonConfig(
                            style: .primary,
                            fitContent: true,
                            cornerRadius: .radius24,
                            backgroundColor: AppColors.white,
                            horizontalPadding: .padding4,
                            verticalPadding: .padding10
                        )
                    ) {
                        // Handle booking type selection
                    } content: {
                        HStack {
                            Text(viewModel.booking.bookingType.rawValue)
                                .font(.system(size: 14))
                                .foregroundStyle(AppColors.textPrimary)
                                .padding(.padding8)
                                .background(Color.grabGreenLight.opacity(0.1))
                                .cornerRadius(.radius16)

                            Image(systemName: "chevron.down")
                                .font(.system(size: .iconSize16))
                                .foregroundStyle(AppColors.textPrimary)
                                .padding(.trailing, .padding8)
                        }
                    }
                }
                .padding(.top, .padding64)
                .padding(.horizontal, .padding16)

                Spacer()

                VStack {
                    HStack {
                        ButtonView(
                            config: ButtonConfig(
                                style: .text,
                                verticalPadding: .padding8
                            )
                        ) {
                            // Handle payment method selection
                        } content: {
                            HStack(spacing: .spacing8) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            AppColors.grabGreenLight
                                                .opacity(.opacity3)
                                        )
                                        .frame(width: .iconSize32, height: .iconSize32)

                                    Image(systemName: "bag")
                                        .font(.system(size: 14))
                                        .foregroundStyle(AppColors.textPrimary)
                                }

                                Text("Tiền mặt")
                                    .font(.system(size: 14))
                                    .foregroundStyle(AppColors.textPrimary)
                            }
                        }


                        Spacer()
                        Divider()
                            .frame(height: .spacing32)

                        ButtonView(
                            config: ButtonConfig(
                                style: .text,
                                verticalPadding: .padding8
                            )
                        ) {
                            // Handle payment method selection
                        } content: {
                            HStack(spacing: .spacing8) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            AppColors.grabGreen
                                        )
                                        .frame(
                                            width: .iconSize20, height:.iconSize20)

                                    Image(systemName: "checkmark")
                                        .font(.system(size: .iconSize12))
                                        .foregroundStyle(AppColors.white)
                                }

                                Text("KCTGHNAATG")
                                    .font(.system(size: 14))
                                    .foregroundStyle(AppColors.textPrimary)
                            }
                        }

                        Divider()
                            .frame(height: .spacing32)

                        ButtonView(
                            config: ButtonConfig(
                                style: .text,
                                fitContent: true,
                                horizontalPadding: .padding12,
                                verticalPadding: .padding8
                            )
                        ) {
                            // Handle payment method selection
                        } content: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: .iconSize24))
                                .foregroundStyle(AppColors.textPrimary)
                        }

                    }
                    .padding(.horizontal, .padding8)
                    .padding(.bottom, .padding8)

                    ButtonView(
                        title: "Chọn",
                        config: ButtonConfig(
                            style: .primary,
                            fontSize: .headline
                        ),
                        action: {
                            viewModel.toggleRoute()
                        }
                    )
                    .padding(.horizontal, .padding20)
                }
                .padding(.top, .padding16)
                .padding(.bottom, .padding42)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BookDriverView()
}
