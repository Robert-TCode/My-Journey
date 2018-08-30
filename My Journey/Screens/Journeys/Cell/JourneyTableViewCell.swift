//
//  JourneyTableViewCell.swift
//  My Journey
//
//  Created by Robert Tanase on 29/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import UIKit

class JourneyTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    func configure(withJourney journey: Journey) {
        let truncatedDistance = String(format: "%.2f",
                                     journey.totalDistance)
        let truncatedDurationInSeconds = Int(journey.duration / 1000.0)
        let hours = truncatedDurationInSeconds / 3600
        let mins = (truncatedDurationInSeconds - (hours * 3600)) / 60
        let sec = truncatedDurationInSeconds - (hours * 3600) - (mins * 60)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        let stringDate = dateFormatter.string(from: Date(timeIntervalSince1970: journey.date))
        dateLabel.text = stringDate
        timeLabel.text = "\(hours)h \(mins)mins \(sec) sec"
        distanceLabel.text = "\(truncatedDistance) mi"
    }
}
