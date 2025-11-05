//
//  CategoryView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 22/10/25.
//

import SwiftUI

struct HomeCategoryView: View {
    let coordinator: HomeCoordinator
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
                        coordinator.navigateToCategory(category)
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
    let router = Router()
    let appState = AppState()
    let coordinator = HomeCoordinator(router: router, appState: appState)

    return HomeCategoryView(coordinator: coordinator)
}
