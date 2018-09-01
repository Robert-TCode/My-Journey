//
//  Date+Extension.swift
//  My Journey
//
//  Created by Victor Stanescu on 01/09/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation

public enum DateStringFormat {
    case fullDate
    case calendar
    case time
    
    var dateFormat: String {
        switch self {
        case .fullDate: return "MMM dd, HH:mm"
        case .calendar: return "MMM dd, yyy"
        case .time: return "HH:mm:ss"
        }
    }
}

public extension Date {
    // Method used to convert a date in different string formats
    func convertToString(inFormat format: DateStringFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.dateFormat
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}
