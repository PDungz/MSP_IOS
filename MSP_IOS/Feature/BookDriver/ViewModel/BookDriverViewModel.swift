//
//  BookDriverViewModel.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 31/10/25.
//

import Foundation
import MapKit
import Combine

@MainActor
class BookDriverViewModel: ObservableObject {
    @Published var booking: BookingModel
    @Published var mapConfig: MapConfiguration
    @Published var availablePaymentMethods: [PaymentMethodModel]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init() {
        self.mapConfig = .default

        let startLocation = LocationModel(
            coordinate: CLLocationCoordinate2D(latitude: 21.0285, longitude: 105.8542),
            title: "Start"
        )

        let endLocation = LocationModel(
            coordinate: CLLocationCoordinate2D(latitude: 21.0385, longitude: 105.8642),
            title: "End"
        )

        let paymentMethods = [
            PaymentMethodModel(type: .cash, isSelected: true),
            PaymentMethodModel(type: .grabPay, displayName: "KCTGHNAATG", isSelected: false)
        ]

        self.availablePaymentMethods = paymentMethods

        self.booking = BookingModel(
            startLocation: startLocation,
            endLocation: endLocation,
            selectedPaymentMethod: paymentMethods.first!
        )
    }

    func toggleRoute() {
        mapConfig.showRoute.toggle()
    }

    func zoomIn() {
        mapConfig.region.span.latitudeDelta /= 2
        mapConfig.region.span.longitudeDelta /= 2
    }

    func zoomOut() {
        mapConfig.region.span.latitudeDelta *= 2
        mapConfig.region.span.longitudeDelta *= 2
    }

    func updateRegion(_ region: MKCoordinateRegion) {
        mapConfig.region = region
    }

    func selectBookingType(_ type: BookingType) {
        booking.bookingType = type
    }

    func selectPaymentMethod(_ method: PaymentMethodModel) {
        availablePaymentMethods = availablePaymentMethods.map { payment in
            var updated = payment
            updated.isSelected = payment.id == method.id
            return updated
        }

        if let selected = availablePaymentMethods.first(where: { $0.isSelected }) {
            booking.selectedPaymentMethod = selected
        }
    }

    func calculateRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) async {
        isLoading = true

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        do {
            let response = try await directions.calculate()

            if let route = response.routes.first {
                let routeModel = RouteModel(
                    polyline: route.polyline,
                    distance: route.distance,
                    expectedTravelTime: route.expectedTravelTime,
                    steps: route.steps.map { $0.instructions }
                )

                self.booking.route = routeModel
            }
        } catch {
            self.errorMessage = "Không thể tính toán lộ trình: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func confirmBooking() {
        guard booking.isValid else {
            errorMessage = "Vui lòng chọn điểm đi và điểm đến"
            return
        }

        print("Booking confirmed:")
        print("- Type: \(booking.bookingType.rawValue)")
        print("- Payment: \(booking.selectedPaymentMethod.displayName)")
        print("- Distance: \(booking.route?.formattedDistance ?? "N/A")")
    }
}
