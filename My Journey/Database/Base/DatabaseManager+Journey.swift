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
    public func getJourneys() -> [Journey] {
        let journeys = realm.objects(Journey.self)
            .sorted(byKeyPath: "date")
        return Array(journeys)
    }

    public func getJourney(withUUID uuid: String) -> Journey? {
        let journey = realm.objects(Journey.self)
            .first(where: { $0.uuid == uuid } )
        return journey
    }
}
