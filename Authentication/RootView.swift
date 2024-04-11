//
//  RootView.swift
//  NutriMind
//
//  Created by Preeten Dali on 10/01/24.
//

import SwiftUI

struct RootView: View {
    @StateObject var manager = HealthManager()
    @State private var showSignInView: Bool = false
    
    var body: some View {
        ZStack{
            NavigationStack{
                HomeTabView(showSignInView: $showSignInView)
                    .environmentObject(manager)
            }
        }.onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack{
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
