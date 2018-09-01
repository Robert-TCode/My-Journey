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
    @IBOutlet weak var currentSpeedLabel: UILabel!
    @IBOutlet weak var mapKitView: MKMapView!

    let creater = JourneyCreater()

    var coordinatesArray = [Coordinates]()
    var startTimestamp: Double = 0
    var endTimestamp: Double = 0
    var distance: Double = 0 {
        didSet {
            let truncatedDistance = String(format: "%.2f", distance / 1000.0)
            distanceLabel.text = "\(truncatedDistance) km"
        }
    }
    var instantSpeed: Double = 0.0 {
        didSet {
            if instantSpeed == 0.0 {
                currentSpeedLabel.text = "--- km / h"
            } else {
                let truncatedSpeedString = String(format: "%.2f", instantSpeed)
                currentSpeedLabel.text = "\(truncatedSpeedString) km/h"
            }
        }
    }

    var tracking: Bool = true {
        didSet {
            if tracking {
                locationManager.startUpdatingLocation()
                startTimestamp = Date().timeIntervalSince1970
            } else {
                locationManager.stopUpdatingLocation()
                oldCoordinates = nil
                endTimestamp = Date().timeIntervalSince1970
                saveJourney()
                instantSpeed = 0.0
            }
        }
    }

    var locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 100
    var oldCoordinates: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        oldCoordinates = locationManager.location?.coordinate
        tracking = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackingSwitch.setOn(tracking, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServiceAuthenticationStatus()
    }

    private func checkLocationServiceAuthenticationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapKitView.showsUserLocation = true
            if tracking {
                locationManager.startUpdatingLocation()
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            if tracking {
                locationManager.startUpdatingLocation()
            }
        }
    }

    private func zoomOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 3.0,
                                                                  regionRadius * 3.0)
        mapKitView.setRegion(coordinateRegion, animated: true)
    }

    private func drawOnMap() {
        guard let source = oldCoordinates,
            let destination = locationManager.location?.coordinate else {
                return
        }
        let polyline = MKPolyline(coordinates: [source, destination], count: 2)
        self.mapKitView.add(polyline, level: .aboveRoads)

        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let distanceInMeters = destinationLocation.distance(from: sourceLocation)
        distance += distanceInMeters
        
        // instant speed calculation
        if let lastCoordinate = coordinatesArray.last {
            let time = Date().timeIntervalSince1970 - lastCoordinate.timestamp
            let metersPerSecond = distanceInMeters / time
            instantSpeed = metersPerSecond * 3.6
        }

        if coordinatesArray.isEmpty {
            let sourceCoordinates = Coordinates(uuid: UUID().uuidString,
                                         timestamp: Date().timeIntervalSince1970,
                                         latitude: source.latitude,
                                         longitude: source.longitude)
            coordinatesArray.append(sourceCoordinates)
        }
        let destinationCoordinates = Coordinates(uuid: UUID().uuidString,
                                            timestamp: Date().timeIntervalSince1970,
                                            latitude: destination.latitude,
                                            longitude: destination.longitude)
        coordinatesArray.append(destinationCoordinates)
    }

    private func saveJourney() {
        if coordinatesArray.isEmpty {
            print("Attempt to save empty journey")
            return
        }
        
        let duration = endTimestamp - startTimestamp
        let distanceRaw = String(format: "%.2f", distance)
        guard let journeyDistance = Double(distanceRaw) else {
            print("Failed to truncate distance")
            return
        }
        // handle the trim of decimals better later
        
        let metersPerSecond = journeyDistance / duration
        let kilometersPerHour = metersPerSecond * 3.6
        // 3.6 number for converting meters / sec to kilometerts / hour
        
        let averageSpeedString = String(format: "%.2f", kilometersPerHour)
        guard let averageSpeed = Double(averageSpeedString) else {
            print("Failed to truncate speed")
            return
        }
        
        let journey = Journey(uuid: UUID().uuidString,
                              date: Date().timeIntervalSince1970,
                              duration: duration,
                              totalDistance: journeyDistance,
                              startTime: startTimestamp,
                              endTime: endTimestamp,
                              averageSpeed: averageSpeed,
                              coorinatesArray: coordinatesArray)
        creater.createJourney(journey) {
            print("Journey added to database")
        }

        coordinatesArray.removeAll()
        distance = 0
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
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            self.mapKitView.setRegion(region, animated: true)

            zoomOn(location: location)
            drawOnMap()
            oldCoordinates = location.coordinate
        }
    }
}
