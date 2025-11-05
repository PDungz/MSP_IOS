//
//  RideWithDiscountView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 26/10/25.
//  Updated on 05/11/25 - Removed mock data, use data from API
//

import SwiftUI

/// Model cho ride discount data
///
/// # Overview
/// Struct này đại diện cho một chuyến xe có ưu đãi.
/// Data sẽ được fetch từ API và map vào struct này.
///
/// # Usage
/// ```swift
/// // Map từ API response
/// let rideDiscount = RideDiscount(
///     image: apiResponse.imageUrl,
///     title: apiResponse.locationName,
///     discount: apiResponse.discountPercent
/// )
/// ```
struct RideDiscount: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let discount: String

    init(image: String, title: String, discount: String) {
        self.image = image
        self.title = title
        self.discount = discount
    }
}

/// View hiển thị danh sách các chuyến xe có ưu đãi
///
/// # Overview
/// View này hiển thị horizontal scrollable list của các ride discounts.
/// Data được truyền vào từ parent view (fetch từ API).
///
/// # Usage
/// ```swift
/// // Trong parent view
/// @State private var discounts: [RideDiscount] = []
///
/// RideWithDiscountView(discounts: discounts)
///     .task {
///         // Fetch data từ API
///         discounts = await fetchDiscountsFromAPI()
///     }
/// ```
///
/// - Parameter discounts: Array của RideDiscount objects từ API
struct RideWithDiscountView: View {
    /// Data từ API
    let discounts: [RideDiscount]

    /// Initializer
    /// - Parameter discounts: Array of discount rides (default: empty array)
    init(discounts: [RideDiscount] = []) {
        self.discounts = discounts
    }

    var body: some View {
        VStack{
            headerView

            if discounts.isEmpty {
                emptyStateView
            } else {
                discountScrollView
            }
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
                // TODO: Navigate to all discounts screen
            }
        }
        .padding(.horizontal, .padding20)
    }

    /// Empty state khi chưa có data
    private var emptyStateView: some View {
        HStack {
            Spacer()
            Text("Chưa có ưu đãi nào")
                .font(.subheadline)
                .foregroundColor(AppColors.textSecondary)
                .padding()
            Spacer()
        }
    }

    private var discountScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Array(discounts.enumerated()), id: \.element.id) { index, discount in
                    discountCard(for: discount)
                        .padding(.leading, index == 0 ? .padding20 : 0)
                        .padding(.trailing, index == discounts.count - 1 ? .padding20 : 0)
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
    // Preview với empty state
    RideWithDiscountView(discounts: [])
}

#Preview("With Data") {
    // Preview với sample data cho development
    RideWithDiscountView(discounts: [
        RideDiscount(image: "ThangLong", title: "Hoàng Thành Thăng Long", discount: "20%"),
        RideDiscount(image: "QuocTuGiam", title: "Quốc Tử Giám", discount: "12%"),
        RideDiscount(image: "Hue_DiTich", title: "Kinh Thành Huế", discount: "16%"),
    ])
}
