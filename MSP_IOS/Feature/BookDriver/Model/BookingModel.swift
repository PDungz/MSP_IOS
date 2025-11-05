//
//  BookingModel.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 31/10/25.
//

import Foundation

enum BookingType: String, CaseIterable {
    case forMe = "Bạn"
    case forOthers = "Người khác"
}

struct BookingModel {
    var bookingType: BookingType
    var startLocation: LocationModel?
    var endLocation: LocationModel?
    var selectedPaymentMethod: PaymentMethodModel
    var route: RouteModel?
    var estimatedPrice: Double?

    var isValid: Bool {
        startLocation != nil && endLocation != nil
    }

    init(
        bookingType: BookingType = .forMe,
        startLocation: LocationModel? = nil,
        endLocation: LocationModel? = nil,
        selectedPaymentMethod: PaymentMethodModel = PaymentMethodModel(type: .cash, isSelected: true),
        route: RouteModel? = nil,
        estimatedPrice: Double? = nil
    ) {
        self.bookingType = bookingType
        self.startLocation = startLocation
        self.endLocation = endLocation
        self.selectedPaymentMethod = selectedPaymentMethod
        self.route = route
        self.estimatedPrice = estimatedPrice
    }
}
