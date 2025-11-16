//
//  CategoryView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 22/10/25.
//

import SwiftUI

struct HomeCategoryView: View {
    let categories = Category.allCases

    let rows = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding: CGFloat = .padding16
            let gridSpacing: CGFloat = .spacing16
            let numberOfColumns: CGFloat = 4

            // Tính toán width cho mỗi item
            let totalHorizontalSpacing = gridSpacing * (numberOfColumns - 1)
            let availableWidth = geometry.size.width - (horizontalPadding * 2) - totalHorizontalSpacing
            let itemWidth = availableWidth / numberOfColumns

            LazyHGrid(rows: rows, spacing: gridSpacing) {
                ForEach(categories, id: \.self) { category in
                    Button {
                        navigateToCategory(category)
                    } label: {
                        CategoryItemView(category: category)
                            .frame(width: itemWidth)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, .padding4)
        }
        .frame(height: 200)
    }

    // MARK: - Navigation Helper

    /// Navigate to appropriate screen based on category
    private func navigateToCategory(_ category: Category) {
        switch category {
        case .motorcycle:
            AppNavigation.push(.motorcycleBooking)
        case .car:
            // TODO: Add car booking route
            AppLogger.i("🚗 Navigate to car booking")
        case .food:
            AppNavigation.push(.foodList)
        case .shipping:
            // TODO: Add shipping route
            AppLogger.i("📦 Navigate to shipping")
        case .shopping:
            // TODO: Add shopping route
            AppLogger.i("🛒 Navigate to shopping")
        case .voucher:
            // TODO: Add voucher route
            AppLogger.i("🎫 Navigate to voucher")
        case .bookDriver:
            // TODO: Add book driver route
            AppLogger.i("📅 Navigate to book driver")
        case .all:
            // TODO: Add all categories route
            AppLogger.i("📋 Navigate to all categories")
        }
    }
}

struct CategoryItemView: View {
    let category: Category

    var body: some View {
        VStack(spacing: .spacing8) {
            Image(systemName: category.icon)
                .resizable()
                .scaledToFit()
                .frame(height: .iconSize28)
                .foregroundColor(category.color)

            Text(category.title)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, .padding4)
        .padding(.vertical, .padding12)
        .background(AppColors.grabGreen.opacity(.opacity05))
        .cornerRadius(.radius12)
    }
}

#Preview {
    return HomeCategoryView()
}
