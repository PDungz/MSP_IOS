//
//  TabItem.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 21/10/25.
//

import SwiftUI

enum TabItem: Int, CaseIterable {
    case home = 0
    case payment = 1
    case message = 2

    var title: String {
        switch self {
        case .home:
            return "Trang chủ"
        case .payment:
            return "Thanh toán"
        case .message:
            return "Tin nhắn"
        }
    }

    var icon: String {
        switch self {
        case .home:
            return "house"
        case .payment:
            return "creditcard"
        case .message:
            return "message"
        }
    }

    var selectedIcon: String {
        switch self {
        case .home:
            return "house.fill"
        case .payment:
            return "creditcard.fill"
        case .message:
            return "message.fill"
        }
    }
}
