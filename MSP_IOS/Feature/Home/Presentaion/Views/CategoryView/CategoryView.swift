//
//  CategoryView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 22/10/25.
//

import SwiftUI

struct CategoryView: View {
    let categories = Array(1...10)

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
                ForEach(categories, id: \.self) { index in
                    CategoryItemView(index: index)
                        .frame(width: itemWidth)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, .padding4)
        }
        .frame(height: 200)
    }
}

struct CategoryItemView: View {
    let index: Int

    var body: some View {
        VStack(spacing: .spacing8) {
            Image(systemName: "square.grid.2x2")
                .resizable()
                .scaledToFit()
                .frame(height: .iconSize28)
                .foregroundColor(.blue)

            Text("Category \(index)")
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, .padding12)
        .padding(.vertical, .padding12)
        .background(AppColors.primaryGreenLight.opacity(.opacity1))
        .cornerRadius(.radius12)
        .shadow(color: .black.opacity(.opacity1), radius: .radius2)
    }
}

#Preview {
    CategoryView()
}
