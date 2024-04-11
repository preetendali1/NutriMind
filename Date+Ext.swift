//
//  Date+Ext.swift
//  NutriMind
//
//  Created by Preeten Dali on 28/01/24.
//

import Foundation

extension Date {
    var monthAndDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: self)
    }
    var time: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self)
    }
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: self)
    }
}
