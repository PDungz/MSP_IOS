//
//  AddCardAndGrabRewardsView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 28/10/25.
//

import SwiftUI

struct AddCardAndGrabRewardsView: View {
    var body: some View {
        HStack(spacing: .spacing12) {
            ButtonView(
                config: ButtonConfig(
                    style: .outline,
                    cornerRadius: .radius16,
                    borderColor: AppColors.borderDark,
                    borderWidth: .borderWidth05,
                    horizontalPadding: .padding12,
                    verticalPadding: .padding16
                )
            ) {
                print("Premium")
            } content: {
                HStack {
                    VStack(alignment: .leading ,spacing: .spacing2) {
                        Text("Payment")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                        Text("Add a card")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    .padding(.horizontal, .padding8)
                    Image(systemName: "wallet.bifold.fill")
                        .font(.headline)
                }
            }

            ButtonView(
                config: ButtonConfig(
                    style: .outline,
                    cornerRadius: .radius16,
                    borderColor: AppColors.borderDark,
                    borderWidth: .borderWidth05,
                    horizontalPadding: .padding12,
                    verticalPadding: .padding16
                )
            ) {
                print("Premium")
            } content: {
                HStack {
                    VStack(alignment: .leading ,spacing: .spacing4) {
                        Text("GrabRewards")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                        Text("0")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    .padding(.horizontal, .padding8)
                    Image(systemName: "crown.fill")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    AddCardAndGrabRewardsView()
}
