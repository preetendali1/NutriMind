//
//  HomeView.swift
//  NutriMind
//
//  Created by Preeten Dali on 11/01/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var  manager: HealthManager
    let  welcomeArray = ["🙏","Welcome", "Hello", "Nomoshkaar", "Namaskaar", "Vanakkam"]
    @State private var currentIndex = 0
    var body: some View {
        VStack(alignment: .leading){
            Text(welcomeArray[currentIndex])
                .font(.largeTitle)
                .padding()
                .foregroundColor(.secondary)
                .animation(.easeInOut(duration: 0.5), value: currentIndex)
                .onAppear {
                    startWelcomeTimmer()
                }
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)){
                ForEach(manager.activites.sorted(by: {$0.value.id < $1.value.id}), id:\.key) { item in
                    ActivityCardView(activity: item.value)
                    
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    func startWelcomeTimmer(){
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % welcomeArray.count
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HealthManager())
}
