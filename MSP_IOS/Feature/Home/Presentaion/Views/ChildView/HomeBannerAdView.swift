//
//  HomeBannerAdView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 29/10/25.
//

import SwiftUI

struct ListBannerAdData {
    let title: String
    let url: String
    let subtitle: String
    let desQC: String

    init(title: String, url: String, subtitle: String, desQC: String) {
        self.title = title
        self.url = url
        self.subtitle = subtitle
        self.desQC = desQC
    }

    static let listBannerAdData: [ListBannerAdData] = [
        .init(
            title: "Đặt Ngay",
            url: "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600",
            subtitle: "Giảm 50K cho đơn từ 99K - Áp dụng tất cả món",
            desQC: "Ưu Đãi Hôm Nay"
        ),
        .init(
            title: "Order Ngay",
            url: "https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=600",
            subtitle: "Freeship 0Đ - Giao nhanh 15 phút",
            desQC: "Đối Tác Mới"
        ),
        .init(
            title: "Mua Ngay",
            url: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=600",
            subtitle: "Combo Pizza 1+1 - Giảm đến 40%",
            desQC: "Pizza Napoli"
        ),
        .init(
            title: "Đặt Ngay",
            url: "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=600",
            subtitle: "Ăn sáng chỉ từ 15K - Giao hàng nhanh",
            desQC: "Breakfast Deal"
        ),
        .init(
            title: "Order Ngay",
            url: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600",
            subtitle: "Burger + Khoai tây + Nước giảm 35K",
            desQC: "Burger House"
        ),
        .init(
            title: "Đặt Ngay",
            url: "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=600",
            subtitle: "Set Sushi 10 miếng chỉ 99K",
            desQC: "Sushi Tokyo"
        ),
        .init(
            title: "Order Ngay",
            url: "https://images.unsplash.com/photo-1562059390-a761a084768e?w=600",
            subtitle: "Combo Gà Rán 6 miếng + 2 Pepsi",
            desQC: "KFC Style"
        )
    ]
}

struct HomeBannerAdView: View {

    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(0..<ListBannerAdData.listBannerAdData.count, id: \.self) { index in
                        discountCard(
                            for: ListBannerAdData.listBannerAdData[index]
                        )
                            .padding(.leading, index == 0 ? .padding20 : 0)
                            .padding(.trailing, index == ListBannerAdData.listBannerAdData.count - 1 ? .padding20 : 0)
                    }
                }
            }
        }
    }

    private func headerView(title: String) -> some View {
        return HStack{
            Text(title)
                .font(.system(size: 24, weight: .bold))
            CircleButtonView(
                icon: .system("chevron.forward"),
                iconSize: .iconSize12,
                backgroundColor: AppColors.gray500,
                foregroundColor: AppColors.textInverse,
                size: .iconSize20
            ) {
            }
        }
    }

    private func discountCard(for item: ListBannerAdData) -> some View {
        VStack(alignment: .leading,spacing: 8) {
            headerView(title: item.title)

            CacheImageView(
                source: .url(item.url),
                options: ImageOptions(
                    width: .spacing128 * 2,
                    height: .spacing64 * 2,
                    cornerRadius: .radius12,
                    contentMode: .fill
                )
            )

            cardInfo(subtitle: item.subtitle, desQC: item.desQC)
        }
        .frame(width: .spacing128 * 2)
    }

    private func cardInfo(subtitle: String, desQC: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(subtitle)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(AppColors.textPrimary)
                .lineLimit(2)

            HStack {
                Text("QC ")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
                Text(desQC)
                    .font(.caption)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }


}

#Preview {
    HomeBannerAdView()
}
