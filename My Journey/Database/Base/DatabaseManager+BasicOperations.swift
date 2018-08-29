//
//  DatabaseManager+BasicOperations.swift
//  My Journey
//
//  Created by Robert Tanase on 29/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import RealmSwift

public extension DatabaseManager {
    func write(_ block: @escaping () -> Void, completion: (() -> Void)? = nil ) {
        internalQueue.async {
            do {
                try self.realm.write {
                    block()
                }
            } catch let error as NSError {
                print(error)
            }

            self.externalQueue.async {
                completion?()
            }
        }
    }

    func add(_ object: Object, completion: (() -> Void)? = nil) {
        write({
            self.realm.add(object, update: true)
        }, completion: completion)
    }

    func add(_ objects: [Object], completion: (() -> Void)? = nil) {
        write({
            objects.forEach { self.realm.add($0, update: true) }
        }, completion: completion)
    }

    func add(_ objects: Object..., completion: (() -> Void)? = nil) {
        write({
            objects.forEach { self.realm.add($0, update: true) }
        }, completion: completion)
    }

    func update(_ object: Object, completion: (() -> Void)? = nil) {
        write({
            self.realm.add(object, update: true)
        }, completion: completion)
    }

    func update(_ objects: [Object], completion: (() -> Void)? = nil) {
        write({
            objects.forEach { self.realm.add($0, update: true) }
        }, completion: completion)
    }

    func update(_ objects: Object..., completion: (() -> Void)? = nil) {
        write({
            objects.forEach { self.realm.add($0, update: true) }
        }, completion: completion)
    }

    func delete(_ object: Object, completion: (() -> Void)? = nil) {
        write({
            self.realm.delete(object)
        }, completion: completion)
    }

    func delete(_ objects: [Object], completion: (() -> Void)? = nil) {
        write({
            self.realm.delete(objects)
        }, completion: completion)
    }

    func delete(_ objects: Object..., completion: (() -> Void)? = nil) {
        write({
            self.realm.delete(objects)
        }, completion: completion)
    }
}
