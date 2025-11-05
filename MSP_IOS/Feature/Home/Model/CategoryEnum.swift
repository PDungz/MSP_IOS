//
//  CategoryModel.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 22/10/25.
//

import Foundation
import SwiftUI

enum Category: String, Codable, CaseIterable {
    case motorcycle = "motorcycle"
    case car = "car"
    case food = "food"
    case shipping = "shipping"
    case shopping = "shopping"
    case voucher = "voucher"
    case bookDriver = "book-driver"
    case all = "all"

    var title: String {
        switch self {
        case .motorcycle:
            return "Xe máy"
        case .car:
            return "Ô tô"
        case .food:
            return "Đồ ăn"
        case .shipping:
            return "Giao hàng"
        case .shopping:
            return "Đi chợ"
        case .voucher:
            return "Voucher"
        case .bookDriver:
            return "Đặt xe trước"
        case .all:
            return "Tất cả"
        }
    }

    var icon: String {
        switch self {
        case .motorcycle:
            return "motorcycle.fill"
        case .car:
            return "car.fill"
        case .food:
            return "fork.knife"
        case .shipping:
            return "shippingbox.fill"
        case .shopping:
            return "cart.fill"
        case .voucher:
            return "ticket.fill"
        case .bookDriver:
            return "calendar.badge.clock"
        case .all:
            return "square.grid.2x2.fill"
        }
    }

    var color: Color {
        switch self {
        case .motorcycle:
            return AppColors.grabBike
        case .car:
            return AppColors.grabCar
        case .food:
            return AppColors.grabFood
        case .shipping:
            return AppColors.grabExpress
        case .shopping:
            return AppColors.grabMart
        case .voucher:
            return AppColors.error
        case .bookDriver:
            return AppColors.grabPay
        case .all:
            return AppColors.grabGreen
        }
    }
}

// MARK: - Placeholder Views (thay thế bằng views thực tế của bạn)

struct CarBookingView: View {
    var body: some View {
        Text("Đặt ô tô")
            .navigationTitle("Ô tô")
    }
}

struct FoodOrderView: View {
    var body: some View {
        Text("Đặt đồ ăn")
            .navigationTitle("Đồ ăn")
    }
}

struct ShippingView: View {
    var body: some View {
        Text("Giao hàng")
            .navigationTitle("Giao hàng")
    }
}

struct ShoppingView: View {
    var body: some View {
        Text("Đi chợ")
            .navigationTitle("Đi chợ")
    }
}

struct VoucherView: View {
    var body: some View {
        Text("Voucher của tôi")
            .navigationTitle("Voucher")
    }
}

struct AllCategoriesView: View {
    var body: some View {
        AllCategoriesContentView()
    }
}

struct AllCategoriesContentView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Tất cả dịch vụ")
                        .font(.title2)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                Divider()

                // Content - Danh sách tất cả categories
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 16
                    ) {
                        ForEach(Category.allCases.filter { $0 != .all }, id: \.self) { category in
                            CategoryButton(category: category, dismiss: dismiss)
                        }
                    }
                    .padding()
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Helper View to Break Down Complexity

private struct CategoryButton: View {
    let category: Category
    let dismiss: DismissAction

    var body: some View {
        Button {
            // Dismiss sheet first
            dismiss()

            // Then navigate to category
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                navigateToCategory(category)
            }
        } label: {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .foregroundColor(category.color)

                Text(category.title)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func navigateToCategory(_ category: Category) {
        switch category {
        case .motorcycle:
            AppNavigation.navigateToMotorcycleBooking()
        case .car:
            AppLogger.i("🚗 Navigate to car booking")
        case .food:
            AppNavigation.navigateToFoodList()
        case .shipping:
            AppLogger.i("📦 Navigate to shipping")
        case .shopping:
            AppLogger.i("🛒 Navigate to shopping")
        case .voucher:
            AppLogger.i("🎫 Navigate to voucher")
        case .bookDriver:
            AppLogger.i("📅 Navigate to book driver")
        case .all:
            AppLogger.i("📋 Navigate to all categories")
        }
    }
}
