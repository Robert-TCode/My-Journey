//
//  MapTrackingViewController.swift
//  My Journey
//
//  Created by Robert Tanase on 28/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class MapTrackingViewController: UIViewController {
    
    @IBOutlet weak var trackingSwitch: UISwitch!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapKitView: MKMapView!

    var coordinatesArray = [CLLocationCoordinate2D]()

    var tracking: Bool = true {
        didSet {
            if tracking {
                locationManager.startUpdatingLocation()
            } else {
                locationManager.stopUpdatingLocation()
                oldCoordinates = nil
                // save the journey
                coordinatesArray.removeAll()
            }
        }
    }

    var locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 100
    var oldCoordinates: CLLocationCoordinate2D?
    var distance: Double = 0 {
        didSet {
            let truncatedNumber = String(format: "%.2f", distance / 100.0)
            distanceLabel.text = "\(truncatedNumber) mi"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        oldCoordinates = locationManager.location?.coordinate
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServiceAuthenticationStatus()
    }

    func checkLocationServiceAuthenticationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapKitView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    func zoomOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 3.0,
                                                                  regionRadius * 3.0)
        mapKitView.setRegion(coordinateRegion, animated: true)
    }

    func drawOnMap() {
        guard let source = oldCoordinates,
            let destination = locationManager.location?.coordinate else {
                return
        }
        let polyline = MKPolyline(coordinates: [source, destination], count: 2)
        self.mapKitView.add(polyline, level: .aboveRoads)
        let routeRect = polyline.boundingMapRect
        self.mapKitView.setRegion(MKCoordinateRegionForMapRect(routeRect), animated: true)

        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let distanceInMeters = destinationLocation.distance(from: sourceLocation)
        distance += distanceInMeters

        if coordinatesArray.isEmpty {
            coordinatesArray.append(source)
        }
        coordinatesArray.append(destination)
    }
}

// MARK: Actions
extension MapTrackingViewController {
    @IBAction func didChangeTrackingValue(_ sender: UISwitch) {
        tracking = sender.isOn
    }
}

// MARK: MKMapViewDelegate
extension MapTrackingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 6

        return renderer
    }
}

// MARK: CLLocationManagerDelegate
extension MapTrackingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapKitView.showsUserLocation = true
        if let location = locations.last {
            zoomOn(location: location)
            drawOnMap()
            oldCoordinates = location.coordinate
        }
    }
}
