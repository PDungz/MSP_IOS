//
//  HomeRoute.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 23/10/25.
//

import Foundation

enum HomeRoute: Route {
    case home
    case motorcycleBooking
    case carBooking
    case foodOrder
    case shipping
    case shopping
    case voucher
    case bookDriver
    case allCategories

    var id: String {
        switch self {
        case .home: return "home"
        case .motorcycleBooking: return "motorcycleBooking"
        case .carBooking: return "carBooking"
        case .foodOrder: return "foodOrder"
        case .shipping: return "shipping"
        case .shopping: return "shopping"
        case .voucher: return "voucher"
        case .bookDriver: return "bookDriver"
        case .allCategories: return "allCategories"
        }
    }
}
