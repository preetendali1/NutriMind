//
//  SettingsViewModel.swift
//  NutriMind
//
//  Created by Preeten Dali on 26/03/24.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    var showSignInView: Binding<Bool> 

    init(showSignInView: Binding<Bool>) {
        self.showSignInView = showSignInView
    }

    func signOut() async throws {
        try AuthenticationManager.shared.signOut()
        showSignInView.wrappedValue = true
    }

    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }

    func updateEmail() async throws {
        let email = "preetendali@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
}
