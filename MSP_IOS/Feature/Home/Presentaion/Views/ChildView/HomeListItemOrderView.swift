//
//  HomeBannerAdView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 28/10/25.
//

import SwiftUI

struct ListItemOrderData {
    let image: String
    let title: String
    let km: String
    let rating: Double
    let discount: String

    init(image: String, title: String, km: String, rating: Double, discount: String) {
        self.image = image
        self.title = title
        self.discount = discount
        self.km = km
        self.rating = rating
    }

    static let sampleData: [ListItemOrderData] = [
        .init(image: "ThangLong", title: "Trà Sữa Winggo - Tra Sữa Kem Trứng", km: "3.2km", rating: 4.5,
              discount: "14.000đ"),
        .init(image: "QuocTuGiam", title: "Cơm Thố An Nguyễn - Vũ Tông Phan", km: "8.3km", rating: 4.2, discount: "12.000đ"),
        .init(image: "Hue_DiTich", title: "Hùng Food - Mì Trộn Indomie - Mì Quảng Ngai", km: "5.1km", rating: 4.3, discount: "16.000đ"),
    ]
}

struct HomeListItemOrderView: View {
    let headerTitle: String

    var body: some View {
        VStack{
            headerView
            discountScrollView
        }
    }

    private var headerView: some View {
        return HStack{
            Text(headerTitle)
                .font(.system(size: 20, weight: .bold))
            Spacer()
            CircleButtonView(
                icon: .system("arrow.right"),
                iconSize: .iconSize16,
                backgroundColor: AppColors.grabGreen.opacity(.opacity12),
                foregroundColor: AppColors.textPrimary,
                size: .iconSize32
            ) {
            }
        }
        .padding(.horizontal, .padding20)
    }

    private var discountScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<ListItemOrderData.sampleData.count, id: \.self) { index in
                    discountCard(for: ListItemOrderData.sampleData[index])
                        .padding(.leading, index == 0 ? .padding20 : 0)
                        .padding(.trailing, index == RideDiscount.sampleData.count - 1 ? .padding20 : 0)
                }
            }
        }
    }

    private func discountCard(for item: ListItemOrderData) -> some View {
        VStack(spacing: 8) {
            cardImage(item.image)

            cardInfo(title: item.title, km: item.km, rating: item.rating, discount: item.discount)
        }
        .frame(width: 148)
    }

    private func cardImage(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 148, height: 148)
            .clipped()
            .cornerRadius(8)
    }

    private func cardInfo(title: String, km: String, rating: Double, discount: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            titleText(title)

            kmAndRatingView(km: km, rating: rating)

            discountBadge(discount)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func titleText(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(AppColors.textPrimary)
            .lineLimit(2)
    }

    private func kmAndRatingView(km: String, rating: Double) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Text(km)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
            
            Image(systemName: "star.fill")
                .foregroundColor(AppColors.warning)
            Text("\(rating)")
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
    }

    private func discountBadge(_ text: String) -> some View {
        HStack {
            Image(systemName: "tag.fill")
                .font(.caption)
                .foregroundColor(AppColors.error)


            Text("Giảm \(text)")
                .font(.caption2)
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .overlay(
            RoundedRectangle(cornerRadius: .radius8)
                .stroke(
                    AppColors.borderDark,
                    lineWidth: .borderWidth05
                )
        )
    }

}

#Preview {
    HomeListItemOrderView(headerTitle: "Title Name")
}
