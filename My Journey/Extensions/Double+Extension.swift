//
//  Double+Extension.swift
//  My Journey
//
//  Created by Victor Stanescu on 01/09/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation

public extension Double {
    // Method used for truncate a double number to a specific number of decimals
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
