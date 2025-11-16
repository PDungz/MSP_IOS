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

extension RideDiscount {
    static let mockData1: [RideDiscount] = [
        RideDiscount(
            image: "https://images.unsplash.com/photo-1555217851-6141535bd771?w=400",
            title: "Sân bay Nội Bài",
            discount: "25%"
        ),
        RideDiscount(
            image: "https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=400",
            title: "Hồ Gươm",
            discount: "20%"
        ),
        RideDiscount(
            image: "https://images.unsplash.com/photo-1528127269322-539801943592?w=400",
            title: "Vincom Mega Mall",
            discount: "15%"
        ),
        RideDiscount(
            image: "https://images.unsplash.com/photo-1590069261209-f8e9b8642343?w=400",
            title: "Chùa Một Cột",
            discount: "18%"
        ),
        RideDiscount(
            image: "https://images.unsplash.com/photo-1509023464722-18d996393ca8?w=400",
            title: "Lăng Chủ tịch HCM",
            discount: "22%"
        ),
    ]
}

extension RideDiscount {
    static let mockData2: [RideDiscount] = [
        RideDiscount(
            image: "https://images.unsplash.com/photo-1509023464722-18d996393ca8?w=400",
            title: "Lăng Chủ tịch HCM",
            discount: "22%"
        ),
        RideDiscount(
            image: "https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=400",
            title: "Nhà hát Lớn Hà Nội",
            discount: "12%"
        ),
        RideDiscount(
            image: "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400",
            title: "Bảo tàng Lịch sử",
            discount: "16%"
        ),
        RideDiscount(
            image: "https://images.unsplash.com/photo-1582407947304-fd86f028f716?w=400",
            title: "Cầu Long Biên",
            discount: "10%"
        ),
        RideDiscount(
            image: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400",
            title: "Hồ Tây",
            discount: "14%"
        ),
        RideDiscount(
            image: "https://images.unsplash.com/photo-1553913861-c0fddf2619ee?w=400",
            title: "Phố cổ Hà Nội",
            discount: "20%"
        ),
        RideDiscount(
            image: "https://images.unsplash.com/photo-1541417904950-b855846fe074?w=400",
            title: "Vinpearl Aquarium",
            discount: "30%"
        ),
        RideDiscount(
            image: "https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400",
            title: "Trung tâm AEON Mall",
            discount: "18%"
        )
    ]
}

/// - Parameter discounts: Array của RideDiscount objects từ API
struct RideWithDiscountView: View {
    /// Data từ API
    let discounts: [RideDiscount]

    /// Initializer
    /// - Parameter discounts: Array of discount rides (default: mock data)
    init(discounts: [RideDiscount] = RideDiscount.mockData1) {
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
            CacheImageView(
                url: item.image,
                width: 120, height: 120,
                cornerRadius: Dimension.Raduis.r12
            )


            cardInfo(title: item.title, discount: item.discount)
        }
        .frame(width: 120)
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
    // Preview với mock data
    RideWithDiscountView()
}

#Preview("Empty State") {
    // Preview với empty state
    RideWithDiscountView(discounts: [])
}
