//
//  DatabaseManager+Journey.swift
//  My Journey
//
//  Created by Robert Tanase on 29/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import RealmSwift

public extension DatabaseManager {
    // Return all the journeyes in database
    public func getJourneys() -> [Journey] {
        let journeys = realm.objects(Journey.self)
            .sorted(byKeyPath: "date")
        return Array(journeys)
    }

    // Return the journey with specific UUID or nil in case it can't find one
    public func getJourney(withUUID uuid: String) -> Journey? {
        let journey = realm.objects(Journey.self)
            .first(where: { $0.uuid == uuid } )
        return journey
    }
}
