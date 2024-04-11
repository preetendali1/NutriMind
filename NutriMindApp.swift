//
//  NutriMindApp.swift
//  NutriMind
//
//  Created by Preeten Dali on 10/01/24.
//

import SwiftUI
import Firebase
import SwiftData

@main
struct NutrimindApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Macro.self,
            ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(sharedModelContainer)
    }
}
