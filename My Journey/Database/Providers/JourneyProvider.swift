//
//  JourneyProvider.swift
//  My Journey
//
//  Created by Robert Tanase on 29/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import RealmSwift

public protocol JourneyProviding {
    func getJourneys() -> [Journey]
    func getJourney(withUUID uuid: String) -> Journey?
}

public class JourneyProvider: JourneyProviding {
    public init () { }

    public func getJourneys() -> [Journey] {
        let database = DatabaseManager.shared
        return database.getJourneys()
    }

    public func getJourney(withUUID uuid: String) -> Journey? {
        let database = DatabaseManager.shared
        return database.getJourney(withUUID: uuid)
    }
}
