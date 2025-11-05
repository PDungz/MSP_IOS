//
//  HomeListItemOrderView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 28/10/25.
//  Updated on 05/11/25 - Removed mock data, use data from API
//

import SwiftUI

/// Model cho restaurant/store order item data
///
/// # Overview
/// Struct này đại diện cho một nhà hàng/cửa hàng có ưu đãi trên trang Home.
/// Data sẽ được fetch từ API và map vào struct này.
///
/// # Usage
/// ```swift
/// // Map từ API response
/// let orderItem = ListItemOrderData(
///     image: apiResponse.storeImageUrl,
///     title: apiResponse.storeName,
///     km: apiResponse.distanceInKm,
///     rating: apiResponse.averageRating,
///     discount: apiResponse.discountAmount
/// )
/// ```
struct ListItemOrderData: Identifiable {
    let id = UUID()
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
}

/// View hiển thị danh sách các store/restaurant có ưu đãi
///
/// # Overview
/// View này hiển thị horizontal scrollable list của các stores với discount.
/// Data được truyền vào từ parent view (fetch từ API).
///
/// # Usage
/// ```swift
/// // Trong parent view (HomeView)
/// @State private var stores: [ListItemOrderData] = []
///
/// HomeListItemOrderView(
///     headerTitle: "Ưu đãi gần bạn",
///     items: stores
/// )
/// .task {
///     // Fetch data từ API
///     stores = await fetchStoresFromAPI()
/// }
/// ```
///
/// - Parameters:
///   - headerTitle: Tiêu đề của section
///   - items: Array của ListItemOrderData objects từ API
struct HomeListItemOrderView: View {
    let headerTitle: String
    /// Data từ API
    let items: [ListItemOrderData]

    /// Initializer
    /// - Parameters:
    ///   - headerTitle: Section title
    ///   - items: Array of order items (default: empty array)
    init(headerTitle: String, items: [ListItemOrderData] = []) {
        self.headerTitle = headerTitle
        self.items = items
    }

    var body: some View {
        VStack{
            headerView

            if items.isEmpty {
                emptyStateView
            } else {
                discountScrollView
            }
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
                // TODO: Navigate to all stores screen
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
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    discountCard(for: item)
                        .padding(.leading, index == 0 ? .padding20 : 0)
                        .padding(.trailing, index == items.count - 1 ? .padding20 : 0)
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
            Text("\(rating, specifier: "%.1f")")
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
    // Preview với empty state
    HomeListItemOrderView(headerTitle: "Ưu đãi gần bạn", items: [])
}

#Preview("With Data") {
    // Preview với sample data cho development
    HomeListItemOrderView(
        headerTitle: "Ưu đãi gần bạn",
        items: [
            ListItemOrderData(
                image: "ThangLong",
                title: "Trà Sữa Winggo - Tra Sữa Kem Trứng",
                km: "3.2km",
                rating: 4.5,
                discount: "14.000đ"
            ),
            ListItemOrderData(
                image: "QuocTuGiam",
                title: "Cơm Thố An Nguyễn - Vũ Tông Phan",
                km: "8.3km",
                rating: 4.2,
                discount: "12.000đ"
            ),
            ListItemOrderData(
                image: "Hue_DiTich",
                title: "Hùng Food - Mì Trộn Indomie - Mì Quảng Ngai",
                km: "5.1km",
                rating: 4.3,
                discount: "16.000đ"
            ),
        ]
    )
}
