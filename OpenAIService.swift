//
//  OpenAIService.swift
//  NutriMind
//
//  Created by Preeten Dali on 24/01/24.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

enum OpenAIError: Error {
    case noFunctionCall
    case unableToConvertStringIntoData
}

class OpenAIService {
    
    static let shared = OpenAIService()
    
    private init() {}
    
    private func generateURLRequest(httpMethod: HTTPMethod, message: String) throws -> URLRequest {
        guard let url = URL(string: "http://api.openai.com/v1/chat/completions") else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
        //Method
        urlRequest.httpMethod = httpMethod.rawValue
        
        //Header
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(Secrete.apiKey)", forHTTPHeaderField: "Authorization")
        
        //Body
        let systemMessage = GPTMessage(role: "system", content: "You are a macronutrient expert.")
        let userMessage = GPTMessage(role: "user", content: message)
        
        let food = GPTFunctionProperty(type: "string", description: "The food item e.g. humburger")
        let fats = GPTFunctionProperty(type: "integer", description: "The amount of fats in grams of the given food item")
        let carbs = GPTFunctionProperty(type: "integer", description: "The amount of carbohydrates in grams of the given food item")
        let protein = GPTFunctionProperty(type: "integer", description: "The amount of proteins in grams of the given food item")
        let params: [String: GPTFunctionProperty] = [
            "food": food,
            "fats": fats,
            "carbs": carbs,
            "protein": protein
        
        ]
        
        let functionParam = GPTFunctionParam(type: "object", properties: params, required: ["food", "fats", "carbs", "protein"])
        let function = GPTFunction(name: "get_macronutrients", description: "Get the macronutrients for a given food.", parameters: functionParam)
        let payload = GPTChatpayload(model: "gpt-3.5-turbo", messages: [systemMessage, userMessage], functions: [function])
        
        let jsonData = try JSONEncoder().encode(payload)
        
        urlRequest.httpBody = jsonData
        
        return urlRequest
    }
    
    
    func sendPromptToChatGPT(message: String) async throws -> MecroResult {
        let urlRequest = try generateURLRequest(httpMethod: .post, message: message)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let result = try JSONDecoder().decode(GPTResponse.self, from: data)
        
        guard let functionCall = result.choices[0].message.functionCall else {
            throw OpenAIError.noFunctionCall
        }
        guard let argData = functionCall.arguments.data(using: .utf8) else {
            throw OpenAIError.unableToConvertStringIntoData
        }
        let macro = try JSONDecoder().decode(MecroResult.self, from: argData)
        return macro
    }
}

