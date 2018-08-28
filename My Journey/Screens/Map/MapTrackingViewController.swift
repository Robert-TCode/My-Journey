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
    @IBOutlet weak var mapKitView: MKMapView!

    var locationManager = CLLocationManager()
    private let regionRadius: CLLocationDistance = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        locationManager.delegate = self

        // display current location
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
                                                                  regionRadius * 2.0,
                                                                  regionRadius * 2.0)
        mapKitView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func didChangeTrackingValue(_ sender: UISwitch) {
        // change tracking
    }
}

extension MapTrackingViewController: MKMapViewDelegate {

}

extension MapTrackingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapKitView.showsUserLocation = true
        if let location = locations.last {
            zoomOn(location: location)
        }
    }
}
