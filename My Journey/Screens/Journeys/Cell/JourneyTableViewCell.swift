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
        distanceLabel.text = "\((journey.totalDistance / 1000.0).roundToDecimal(2)) km"
        
        let truncatedDurationInSeconds = Int(journey.duration)
        let hours = truncatedDurationInSeconds / 3600
        let mins = (truncatedDurationInSeconds - (hours * 3600)) / 60
        let sec = truncatedDurationInSeconds - (hours * 3600) - (mins * 60)
        timeLabel.text = "\(hours)h \(mins)mins \(sec) sec"
        
        let date = Date(timeIntervalSince1970: journey.date)
        let stringDate = date.convertToString(inFormat: .fullDate)
        dateLabel.text = stringDate
    }
}
