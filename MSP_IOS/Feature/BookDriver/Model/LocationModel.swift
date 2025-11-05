//
//  LocationModel.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 31/10/25.
//

import Foundation
import CoreLocation
import MapKit

struct LocationModel: Identifiable, Equatable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }

    static func == (lhs: LocationModel, rhs: LocationModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

struct RouteModel {
    let polyline: MKPolyline
    let distance: CLLocationDistance
    let expectedTravelTime: TimeInterval
    let steps: [String]

    var formattedDistance: String {
        let formatter = MKDistanceFormatter()
        return formatter.string(fromDistance: distance)
    }

    var formattedTime: String {
        let minutes = Int(expectedTravelTime / 60)
        return "\(minutes) phút"
    }
}

struct MapConfiguration {
    var mapType: MKMapType
    var showRoute: Bool
    var is3DMode: Bool
    var region: MKCoordinateRegion

    static var `default`: MapConfiguration {
        MapConfiguration(
            mapType: .standard,
            showRoute: false,
            is3DMode: false,
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 21.0285, longitude: 105.8542),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        )
    }
}
