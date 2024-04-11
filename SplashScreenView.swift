//
//  SplashScreenView.swift
//  NutriMind
//
//  Created by Preeten Dali on 10/01/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            Image("logo_transparent")
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFill()
                .ignoresSafeArea()

            if isActive {
                RootView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}


#Preview {
    SplashScreenView()
}
