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
    case activity = 2
    case message = 3

    var title: String {
        switch self {
        case .home:
            return NSLocalizedString("home_category_home", comment: "")
        case .payment:
            return NSLocalizedString("home_category_payment", comment: "")
        case .activity:
            return NSLocalizedString("home_category_activity", comment: "")
        case .message:
            return NSLocalizedString("home_category_message", comment: "")
        }
    }

    var icon: String {
        switch self {
        case .home:
            return "house"
        case .payment:
            return "creditcard"
        case .activity:
            return "list.bullet.rectangle.portrait"
        case .message:
            return "ellipsis.bubble"
        }
    }

    var selectedIcon: String {
        switch self {
        case .home:
            return "house.fill"
        case .payment:
            return "creditcard.fill"
        case .activity:
            return "list.bullet.rectangle.portrait.fill"
        case .message:
            return "ellipsis.bubble.fill"
        }
    }
}
