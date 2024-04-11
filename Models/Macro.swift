//
//  Macro.swift
//  NutriMind
//
//  Created by Preeten Dali on 28/01/24.
//

import Foundation
import SwiftData

@Model
final class Macro {
    
    let food: String
    let createAt: Date
    let date: Date
    let carbs: Int
    let fats: Int
    let protein: Int
    
    init(food: String, createAt: Date, date: Date, carbs: Int, fats: Int, protein: Int) {
        self.food = food
        self.createAt = createAt
        self.date = date
        self.carbs = carbs
        self.fats = fats
        self.protein = protein
    }
}
