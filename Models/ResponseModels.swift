//
//  ResponseModels.swift
//  NutriMind
//
//  Created by Preeten Dali on 26/01/24.
//

import Foundation

struct GPTResponse: Decodable {
    let choices: [GPTCompletion]
}

struct GPTCompletion: Decodable {
    let message: GPTResponseMessage
    
}

struct GPTResponseMessage: Decodable {
    let functionCall: GPTFunctionCall?
    
    enum CodingKeys: String, CodingKey {
        case functionCall = "function_call"
    }
}

struct GPTFunctionCall: Decodable {
    let name: String
    let arguments: String
}

struct MecroResult: Decodable {
    let food: String
    let carbs: Int
    let fats: Int
    let protein: Int
    
}
