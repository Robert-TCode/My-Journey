//
//  JourneyViewController.swift
//  My Journey
//
//  Created by Robert Tanase on 30/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class JourneyViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var mapKitView: MKMapView!
    private let regionRadius: CLLocationDistance = 250
    
    var journey: Journey!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        updateLabels()
        drawPathOnMap()
    }
    
    func configure(withJourney journey: Journey) {
        self.journey = journey
    }
    
    private func updateLabels() {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "MMM dd, yyy"
        var date = Date(timeIntervalSince1970: journey.date)
        var stringDate = dataFormatter.string(from: date)
        dateLabel.text = stringDate
        
        dataFormatter.dateFormat = "HH:mm:ss"
        date = Date(timeIntervalSince1970: journey.startTimestamp)
        stringDate = dataFormatter.string(from: date)
        startTimeLabel.text = stringDate
        date = Date(timeIntervalSince1970: journey.endTimestamp)
        stringDate = dataFormatter.string(from: date)
        endTimeLabel.text = stringDate
        
        let truncatedDistance = String(format: "%.2f", journey.totalDistance / 1000.0)
        totalDistanceLabel.text = "\(truncatedDistance) km"
        averageSpeedLabel.text = "\(journey.averageSpeed) km/h"
    }
    
    private func drawPathOnMap() {
        let coordinates = journey.coordinatesArray
        if coordinates.count < 2 {
            return
        }
        for index in 1..<coordinates.count {
            let source = CLLocationCoordinate2D(latitude: coordinates[index - 1].latitude,
                                                      longitude: coordinates[index - 1].longitude)
            let destination = CLLocationCoordinate2D(latitude: coordinates[index].latitude,
                                                         longitude: coordinates[index].longitude)
            drawPolyline(from: source, to: destination)
        }
        zoomOn(location: CLLocation(latitude: coordinates[0].latitude,
                                    longitude: coordinates[0].longitude))
    }
    
    private func drawPolyline(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let polyline = MKPolyline(coordinates: [source, destination], count: 2)
        self.mapKitView.add(polyline, level: .aboveRoads)
    }
}

extension JourneyViewController: MKMapViewDelegate {
    
    func zoomOn(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 3.0,
                                                                  regionRadius * 3.0)
        mapKitView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .black
        renderer.lineWidth = 5
        
        return renderer
    }
}
