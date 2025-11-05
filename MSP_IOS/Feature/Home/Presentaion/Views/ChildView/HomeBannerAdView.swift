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
        .init(title: "Mua Ngay", url: "https://picsum.photos/400/300", subtitle: "Giảm ngay 25K cho đơn từ 25K", desQC: "Quán Mới Deal Hời"),
        .init(title: "Mua Ngay", url: "https://picsum.photos/200", subtitle: "Bao giá bao ship. - Ưu Đãi X3", desQC: "Grab Ngon bỏ rẻ"),
        .init(title: "Order Ngay", url: "https://picsum.photos/300", subtitle: "Tăng mẫu dùng thử Nescafe khi đặt Grab Food", desQC: "Nescafe")
    ]
}

struct HomeBannerAdView: View {

    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
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
