//
//  DatabaseManager.swift
//  My Journey
//
//  Created by Robert Tanase on 29/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import RealmSwift


/*
 When an iOS app is uninstalled from a device, all of the files associated with it are deleted (including any Realm files).
 For storing data even the user deletes the app, a good solution is to use a server side.
 
 For example, Firebase could be used to store data for users.
 For data separation, they can either make an "account" with an unique username
 or using a device ID to keep their data apart.
 This would change the database architecture a little, being required replacement of Coorinates inside Journey with uuids.
 */


public class DatabaseManager {
    public static var shared = DatabaseManager()

    private init() {
        // Securing database
        // Generate 64 bytes of random data to serve as the encryption key
        let key = NSMutableData(length: 64)!
        
        // Set up a new Realm Configuration object with the key
        let config = Realm.Configuration(encryptionKey: key as Data)
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }

    var realm: Realm! {
        do {
            return try Realm()
        } catch let error as NSError {
            print(error)
            preconditionFailure("Could not instanciate Realm")
        }
    }

    // Queues used for thread management
    let internalQueue = DispatchQueue(label: "DatabaseManager::internal")
    let externalQueue = DispatchQueue(label: "DatabaseManager::external")
}
