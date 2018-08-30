//
//  DatabaseManager.swift
//  My Journey
//
//  Created by Robert Tanase on 29/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import RealmSwift

public class DatabaseManager {
    public static var shared = DatabaseManager()

    private init() { }

    var realm: Realm! {
        do {
            return try Realm()
        } catch let error as NSError {
            print(error)
            preconditionFailure("Could not instanciate Realm")
        }
    }

    let internalQueue = DispatchQueue(label: "DatabaseManager::internal")
    let externalQueue = DispatchQueue(label: "DatabaseManager::external")
}
