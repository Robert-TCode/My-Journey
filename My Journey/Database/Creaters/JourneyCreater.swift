//
//  JourneyCreater.swift
//  My Journey
//
//  Created by Robert Tanase on 29/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import RealmSwift

public protocol JourneyCreating {
    func createJourney(_ journey: Journey,
                       completion: @escaping () -> Void)
}

public class JourneyCreater: JourneyCreating {
    public init() { }

    public func createJourney(_ journey: Journey,
                              completion: @escaping () -> Void) {
    let database = DatabaseManager.shared
        database.add(journey) {
            completion()
        }
    }
}
