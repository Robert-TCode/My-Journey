//
//  Journey.swift
//  My Journey
//
//  Created by Robert Tanase on 29/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import RealmSwift

public class Journey: Object {
    @objc dynamic private(set) var uuid: String = ""
    @objc dynamic private(set) var date: Double = 0
    @objc dynamic private(set) var duration: Double = 0
    @objc dynamic private(set) var totalDistance: Double = 0
    @objc dynamic private(set) var startTimestamp: Double = 0
    @objc dynamic private(set) var endTimestamp: Double = 0
    @objc dynamic private(set) var averageSpeed: Double = 0
    var coordinatesArray = List<Coordinates>()

    convenience init(uuid: String,
                     date: Double,
                     duration: Double,
                     totalDistance: Double,
                     startTime: Double,
                     endTime: Double,
                     averageSpeed: Double,
                     coorinatesArray: [Coordinates]) {
        self.init()
        self.uuid = uuid
        self.date = date
        self.duration = duration
        self.totalDistance = totalDistance
        self.startTimestamp = startTime
        self.endTimestamp = endTime
        self.averageSpeed = averageSpeed
        coorinatesArray.forEach { coordinate in
            self.coordinatesArray.append(coordinate)
        }
    }

    override public static func primaryKey() -> String? {
        return "uuid"
    }

}
