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
            return "scooter"
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
            return .green
        case .car:
            return .blue
        case .food:
            return .orange
        case .shipping:
            return .purple
        case .shopping:
            return .pink
        case .voucher:
            return .red
        case .bookDriver:
            return .indigo
        case .all:
            return .gray
        }
    }

    // Destination view cho navigation
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .motorcycle:
            MotorcycleBookingView()
        case .car:
            CarBookingView()
        case .food:
            FoodOrderView()
        case .shipping:
            ShippingView()
        case .shopping:
            ShoppingView()
        case .voucher:
            VoucherView()
        case .bookDriver:
            BookDriverView()
        case .all:
            AllCategoriesView()
        }
    }
}

// MARK: - Placeholder Views (thay thế bằng views thực tế của bạn)
struct MotorcycleBookingView: View {
    var body: some View {
        Text("Đặt xe máy")
            .navigationTitle("Xe máy")
    }
}

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

struct BookDriverView: View {
    var body: some View {
        Text("Đặt xe trước")
            .navigationTitle("Đặt xe trước")
    }
}

struct AllCategoriesView: View {
    var body: some View {
        Text("Tất cả dịch vụ")
            .navigationTitle("Tất cả")
    }
}
