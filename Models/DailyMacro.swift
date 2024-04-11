//
//  DailyMacro.swift
//  NutriMind
//
//  Created by Preeten Dali on 28/01/24.
//

import Foundation

struct DailyMacro: Identifiable {
    let id = UUID()
    let date: Date
    let carbs: Int
    let fats: Int
    let protein: Int
    
}
