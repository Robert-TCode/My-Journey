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


/*
    UI slows down a lot because of location manager updating process
    There were been tried multiple solution with DeferredLocationUpdates, MonitoringSignificantLocationChanges,
    not displaying user's location on map and other
    Still searching for a better solution 
 */

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
            distanceLabel.text = "\((distance / 1000.0).roundToDecimal(2)) km"
        }
    }
    var instantSpeed: Double = 0.0 {
        didSet {
            if instantSpeed == 0.0 {
                currentSpeedLabel.text = "--- km / h"
            } else {
                currentSpeedLabel.text = "\(instantSpeed.roundToDecimal(2)) km/h"
            }
        }
    }
    
    var tracking: Bool = true {
        didSet {
            if tracking {
                startTracking()
            } else {
                stopTracking()
            }
        }
    }

    var locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 300
    var oldCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapKitView.delegate = self
        mapKitView.showsUserLocation = true
        
        setupLocationManager()
        addObservers()
        
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

    /*
     LocationManager is configured for a better and efficient usage in the following cases:
     - user runs the app in background and the battery consumption in reduced
     - user runs the app in foreground and location has a good accuracy
     - user stops moving and the app detects this and pause / start updating location
     - user uses app while driving or moving long distances
     */
    fileprivate func setupLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .automotiveNavigation
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    fileprivate func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(appMovedToBackground),
                                       name: Notification.Name.UIApplicationWillResignActive,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(appMovedToForeground),
                                       name: NSNotification.Name.UIApplicationDidBecomeActive,
                                       object: nil)
    }
    
    private func checkLocationServiceAuthenticationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if tracking {
                locationManager.startMonitoringSignificantLocationChanges()
                locationManager.startUpdatingLocation()
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            if tracking {
                locationManager.startMonitoringSignificantLocationChanges()
                locationManager.startUpdatingLocation()
            }
        }
    }

    fileprivate func stopTracking() {
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
//        mapKitView.showsUserLocation = false
        
        endTimestamp = Date().timeIntervalSince1970
        oldCoordinates = nil
        saveJourney()
        instantSpeed = 0.0
    }
    
    fileprivate func startTracking() {
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
//        mapKitView.showsUserLocation = true
        startTimestamp = Date().timeIntervalSince1970
    }

    /*
     Once app goes to background, to reduce power consumption,
     location manager continues to monitorize only significant location changes
     */
    @objc func appMovedToBackground() {
        locationManager.stopUpdatingLocation()
    }
    
    /*
     Once app goes to foreground, for higher accuracy,
     location manager starts to monitorize every location updates, not only the significant ones
     */
    @objc func appMovedToForeground() {
        if tracking {
            locationManager.startUpdatingLocation()
        }
    }
    
    /*
     Method called whenever a jouney is ended (finish tracking)
     Add journey to database and reset distance, speed and coordinates array
     */
    private func saveJourney() {
        if coordinatesArray.isEmpty {
            print("Attempt to save empty journey")
            return
        }
        
        let duration = endTimestamp - startTimestamp
        let journeyDistance = distance.roundToDecimal(2)
        
        let metersPerSecond = journeyDistance / duration
        let kilometersPerHour = metersPerSecond * 3.6
        // 3.6 number for converting meters / sec to kilometerts / hour
        let averageSpeed = kilometersPerHour.roundToDecimal(1)
        
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

// MARK: Map Methods
extension MapTrackingViewController {
    /*
     Method called to move the map "camera" to a desired location
     */
    private func zoomOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 3.0,
                                                                  regionRadius * 3.0)
        mapKitView.setRegion(coordinateRegion, animated: true)
    }
    
    /*
     Method called everytime user's location is updated in order to draw the path between coordinates,
     save them, increase total distance and calculate the speed
     */
    private func drawOnMap() {
        guard let source = oldCoordinates,
            let destination = locationManager.location?.coordinate else {
                return
        }
        
        // Add the path between last 2 coordinates
        let polyline = MKPolyline(coordinates: [source, destination], count: 2)
        self.mapKitView.add(polyline, level: .aboveRoads)
        
        // Calculate the distance between last 2 coordinates and add it to total distance
        let sourceLocation = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destinationLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
        let distanceInMeters = destinationLocation.distance(from: sourceLocation)
        distance += distanceInMeters
        
        // Calculate instant speed between last 2 coordinates
        if let lastCoordinate = coordinatesArray.last {
            let time = Date().timeIntervalSince1970 - lastCoordinate.timestamp
            let metersPerSecond = distanceInMeters / time
            instantSpeed = metersPerSecond * 3.6
        }
        
        // Add new coordinate to array
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
        if let location = locations.last {
            zoomOn(location: location)
            drawOnMap()
            oldCoordinates = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopMonitoringSignificantLocationChanges()
            return
        }
        print("Location update failed.")
    }
}
