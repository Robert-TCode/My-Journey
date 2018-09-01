//
//  Coordinates.swift
//  My Journey
//
//  Created by Robert Tanase on 29/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import RealmSwift

public class Coordinates: Object {
    @objc dynamic private(set) var uuid: String = ""
    @objc dynamic private(set) var timestamp: Double = 0
    @objc dynamic private(set) var latitude: Double = 0
    @objc dynamic private(set) var longitude: Double = 0

    convenience init(uuid: String,
                     timestamp: Double,
                     latitude: Double,
                     longitude: Double) {
        self.init()
        self.uuid = uuid
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
    }

    override public static func primaryKey() -> String? {
        return "uuid"
    }
}
