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

extension ListItemOrderData {
    static let mockData1: [ListItemOrderData] = [
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400",
            title: "Nhà hàng Phở 24",
            km: "1.2 km",
            rating: 4.5,
            discount: "Giảm 20%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400",
            title: "Cơm Tấm Sài Gòn",
            km: "0.8 km",
            rating: 4.8,
            discount: "Giảm 30%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1555126634-323283e090fa?w=400",
            title: "Bún Bò Huế Đệ Nhất",
            km: "2.5 km",
            rating: 4.3,
            discount: "Giảm 15%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400",
            title: "Bánh Mì Thịt Nướng",
            km: "0.5 km",
            rating: 4.7,
            discount: "Giảm 25%"
        ),
    ]
}

extension ListItemOrderData {
    static let mockData2: [ListItemOrderData] = [
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400",
            title: "Lẩu Thái Tomyum",
            km: "3.2 km",
            rating: 4.4,
            discount: "Giảm 35%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400",
            title: "Sushi Tokyo",
            km: "2.1 km",
            rating: 4.9,
            discount: "Giảm 20%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400",
            title: "Pizza Ý Napoli",
            km: "1.5 km",
            rating: 4.2,
            discount: "Giảm 40%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400",
            title: "Burger & Steak",
            km: "2.0 km",
            rating: 4.5,
            discount: "Giảm 25%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1551218808-94e220e084d2?w=400",
            title: "Mì Ramen Nhật Bản",
            km: "1.7 km",
            rating: 4.7,
            discount: "Giảm 18%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1562059390-a761a084768e?w=400",
            title: "Gà Rán Crispy",
            km: "1.3 km",
            rating: 4.4,
            discount: "Giảm 22%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400",
            title: "Salad & Healthy Food",
            km: "0.9 km",
            rating: 4.6,
            discount: "Giảm 15%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400",
            title: "Breakfast & Brunch",
            km: "1.1 km",
            rating: 4.8,
            discount: "Giảm 28%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400",
            title: "BBQ Hàn Quốc",
            km: "2.4 km",
            rating: 4.7,
            discount: "Giảm 32%"
        ),
        ListItemOrderData(
            image: "https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400",
            title: "Pancake & Dessert",
            km: "1.6 km",
            rating: 4.5,
            discount: "Giảm 20%"
        )
    ]
}

struct HomeListItemOrderView: View {
    let headerTitle: String
    /// Data từ API
    let items: [ListItemOrderData]

    /// Initializer
    /// - Parameters:
    ///   - headerTitle: Section title
    ///   - items: Array of order items (default: empty array)
    init(headerTitle: String, items: [ListItemOrderData] = ListItemOrderData.mockData1) {
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
            CacheImageView(
                url: item.image,
                width: 148, height: 148,
                cornerRadius: Dimension.Raduis.r12
            )


            cardInfo(title: item.title, km: item.km, rating: item.rating, discount: item.discount)
        }
        .frame(width: 148)
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
    HomeListItemOrderView(headerTitle: "Ưu đãi gần bạn", items: ListItemOrderData.mockData1)
}
