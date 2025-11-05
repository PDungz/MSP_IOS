//
//  MapView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 31/10/25.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    let mapType: MKMapType
    let showRoute: Bool
    let is3DMode: Bool
    let startCoordinate: CLLocationCoordinate2D
    let endCoordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        mapView.showsScale = true
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        if mapView.mapType != mapType {
            mapView.mapType = mapType
        }

        context.coordinator.parent = self

        let currentRegion = mapView.region
        let regionChanged = abs(currentRegion.center.latitude - region.center.latitude) > 0.001 ||
                           abs(currentRegion.center.longitude - region.center.longitude) > 0.001 ||
                           abs(currentRegion.span.latitudeDelta - region.span.latitudeDelta) > 0.001 ||
                           abs(currentRegion.span.longitudeDelta - region.span.longitudeDelta) > 0.001

        if regionChanged && !context.coordinator.isUserInteracting {
            mapView.setRegion(region, animated: true)
        }

        updateCamera(mapView: mapView, context: context)
        updateRoute(mapView: mapView, context: context)
    }

    private func updateCamera(mapView: MKMapView, context: Context) {
        let targetPitch: CGFloat = is3DMode ? 60 : 0
        let targetDistance: CLLocationDistance = is3DMode ? 1000 : 10000

        if abs(mapView.camera.pitch - targetPitch) > 5 {
            let camera = MKMapCamera(
                lookingAtCenter: region.center,
                fromDistance: targetDistance,
                pitch: targetPitch,
                heading: 0
            )
            mapView.setCamera(camera, animated: true)
        }
    }

    private func updateRoute(mapView: MKMapView, context: Context) {
        let coordinator = context.coordinator

        if coordinator.lastShowRoute != showRoute {
            coordinator.lastShowRoute = showRoute

            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })

            coordinator.currentDirections?.cancel()
            coordinator.currentDirections = nil

            if showRoute {
                let startAnnotation = MKPointAnnotation()
                startAnnotation.coordinate = startCoordinate
                startAnnotation.title = "Start"
                mapView.addAnnotation(startAnnotation)

                let endAnnotation = MKPointAnnotation()
                endAnnotation.coordinate = endCoordinate
                endAnnotation.title = "End"
                mapView.addAnnotation(endAnnotation)

                calculateRoute(from: startCoordinate, to: endCoordinate, mapView: mapView, coordinator: coordinator)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func calculateRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, mapView: MKMapView, coordinator: Coordinator) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        coordinator.currentDirections = directions

        directions.calculate { response, error in
            guard coordinator.currentDirections === directions else { return }

            if let error = error {
                print("Route calculation error: \(error.localizedDescription)")
                return
            }

            guard let route = response?.routes.first else {
                print("No route found")
                return
            }

            DispatchQueue.main.async {
                mapView.addOverlay(route.polyline)

                let rect = route.polyline.boundingMapRect
                mapView.setVisibleMapRect(
                    rect,
                    edgePadding: UIEdgeInsets(top: 100, left: 50, bottom: 300, right: 50),
                    animated: true
                )
            }
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var lastShowRoute: Bool = false
        var currentDirections: MKDirections?
        var isUserInteracting: Bool = false

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else { return nil }

            let identifier = "CustomPin"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }

            if annotation.title == "Start" {
                annotationView?.markerTintColor = .green
                annotationView?.glyphImage = UIImage(systemName: "figure.wave")
            } else {
                annotationView?.markerTintColor = .red
                annotationView?.glyphImage = UIImage(systemName: "mappin.circle.fill")
            }

            return annotationView
        }

        func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
            isUserInteracting = true
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            isUserInteracting = false
            DispatchQueue.main.async {
                self.parent.region = mapView.region
            }
        }
    }
}
