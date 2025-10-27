//
//  RideWithDiscountView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 26/10/25.
//

import SwiftUI

struct RideDiscount {
    let image: String
    let title: String
    let discount: String

    init(image: String, title: String, discount: String) {
        self.image = image
        self.title = title
        self.discount = discount
    }

    static let sampleData: [RideDiscount] = [
        .init(image: "ThangLong", title: "Hoàng Thành Thăng Long", discount: "20%"),
        .init(image: "QuocTuGiam", title: "Quốc Tử Giám", discount: "12%"),
        .init(image: "Hue_DiTich", title: "Kinh Thành Huế", discount: "16%"),
    ]
}

struct RideWithDiscountView: View {
    var body: some View {
        VStack{
            headerView
            discountScrollView
        }
    }

    private var headerView: some View {
        HStack{
            Text("Các chuyến xe với ưu đãi")
                .font(.system(size: 20, weight: .bold))
            Spacer()
            CircleButtonView(
                icon: .system("arrow.right"),
                backgroundColor: AppColors.grabGreen.opacity(.opacity12),
                foregroundColor: AppColors.textPrimary,
                size: .iconSize42
            ) {
            }
        }
        .padding(.horizontal, .padding20)
    }

    private var discountScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<RideDiscount.sampleData.count, id: \.self) { index in
                    discountCard(for: RideDiscount.sampleData[index])
                        .padding(.leading, index == 0 ? .padding20 : 0)
                        .padding(.trailing, index == RideDiscount.sampleData.count - 1 ? .padding20 : 0)
                }
            }
        }
    }

    private func discountCard(for item: RideDiscount) -> some View {
        VStack(spacing: 8) {
            cardImage(item.image)

            cardInfo(title: item.title, discount: item.discount)
        }
        .frame(width: 120)
    }

    private func cardImage(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipped()
            .cornerRadius(8)
    }

    private func cardInfo(title: String, discount: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            titleText(title)
            discountBadge(discount)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func titleText(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(AppColors.textPrimary)
            .lineLimit(1)
    }

    private func discountBadge(_ text: String) -> some View {
        Text("Giảm \(text)")
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(AppColors.grabGreen.opacity(.opacity8))
            .cornerRadius(6)
    }

}

#Preview {
    RideWithDiscountView()
}
