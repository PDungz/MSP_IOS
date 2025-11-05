//
//  AppRoute.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 05/11/25.
//  Navigation Routes - Centralized route definitions
//

import Foundation

/// Enum định nghĩa tất cả routes trong app
///
/// # Overview
/// Centralized route management giống go_router trong Flutter.
/// Mỗi case đại diện cho một màn hình trong app.
///
/// # Usage
/// ```swift
/// // Navigate to a route
/// AppNavigation.push(.home)
/// AppNavigation.push(.userDetail(userId: "123"))
///
/// // Pop back
/// AppNavigation.pop()
/// ```
///
/// - Note: Tương tự DpAppRouter trong Flutter
enum AppRoute: Hashable {
    // MARK: - Auth Routes
    case login
    case register
    case forgotPassword

    // MARK: - Main App Routes
    case home
    case profile
    case settings

    // MARK: - User Routes
    case userList
    case userDetail(userId: String)
    case userEdit(userId: String)

    // MARK: - Motorcycle Booking Routes
    case motorcycleBooking
    case motorcycleDetail(motorcycleId: String)
    case bookingConfirm
    case bookingHistory

    // MARK: - Order/Food Routes
    case foodList
    case foodDetail(foodId: String)
    case cart
    case orderConfirm
    case orderHistory

    // MARK: - Other Routes
    case notifications
    case help
    case about

    // MARK: - Properties

    /// Route identifier (for debugging)
    var id: String {
        switch self {
        case .login: return "login"
        case .register: return "register"
        case .forgotPassword: return "forgotPassword"
        case .home: return "home"
        case .profile: return "profile"
        case .settings: return "settings"
        case .userList: return "userList"
        case .userDetail(let userId): return "userDetail/\(userId)"
        case .userEdit(let userId): return "userEdit/\(userId)"
        case .motorcycleBooking: return "motorcycleBooking"
        case .motorcycleDetail(let id): return "motorcycleDetail/\(id)"
        case .bookingConfirm: return "bookingConfirm"
        case .bookingHistory: return "bookingHistory"
        case .foodList: return "foodList"
        case .foodDetail(let id): return "foodDetail/\(id)"
        case .cart: return "cart"
        case .orderConfirm: return "orderConfirm"
        case .orderHistory: return "orderHistory"
        case .notifications: return "notifications"
        case .help: return "help"
        case .about: return "about"
        }
    }

    /// Human-readable title
    var title: String {
        switch self {
        case .login: return "Đăng nhập"
        case .register: return "Đăng ký"
        case .forgotPassword: return "Quên mật khẩu"
        case .home: return "Trang chủ"
        case .profile: return "Hồ sơ"
        case .settings: return "Cài đặt"
        case .userList: return "Danh sách người dùng"
        case .userDetail: return "Chi tiết người dùng"
        case .userEdit: return "Chỉnh sửa người dùng"
        case .motorcycleBooking: return "Đặt xe"
        case .motorcycleDetail: return "Chi tiết xe"
        case .bookingConfirm: return "Xác nhận đặt xe"
        case .bookingHistory: return "Lịch sử đặt xe"
        case .foodList: return "Danh sách món ăn"
        case .foodDetail: return "Chi tiết món ăn"
        case .cart: return "Giỏ hàng"
        case .orderConfirm: return "Xác nhận đơn hàng"
        case .orderHistory: return "Lịch sử đơn hàng"
        case .notifications: return "Thông báo"
        case .help: return "Trợ giúp"
        case .about: return "Giới thiệu"
        }
    }
}
