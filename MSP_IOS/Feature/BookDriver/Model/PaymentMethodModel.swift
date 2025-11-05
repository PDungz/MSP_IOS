//
//  PaymentMethodModel.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 31/10/25.
//

import Foundation

enum PaymentMethodType: String, CaseIterable, Identifiable {
    case cash = "Tiền mặt"
    case grabPay = "GrabPay"
    case creditCard = "Thẻ tín dụng"
    case other = "Khác"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .cash:
            return "bag"
        case .grabPay:
            return "checkmark"
        case .creditCard:
            return "creditcard"
        case .other:
            return "ellipsis"
        }
    }
}

struct PaymentMethodModel: Identifiable {
    let id = UUID()
    let type: PaymentMethodType
    let displayName: String
    var isSelected: Bool

    init(type: PaymentMethodType, displayName: String? = nil, isSelected: Bool = false) {
        self.type = type
        self.displayName = displayName ?? type.rawValue
        self.isSelected = isSelected
    }
}
