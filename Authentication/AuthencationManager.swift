//
//  AuthencationManager.swift
//  NutriMind
//
//  Created by Preeten Dali on 10/01/24.
//

import Foundation
import FirebaseAuth
import FirebaseAuth

struct AuthDataResultDataModel {
    let uid: String
    let email: String?
    let photoURL: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthDataResultDataModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultDataModel(user: user)
    }
    
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID){
                providers.append(option)
            } else {
                assertionFailure("Provider option not Found: \(provider.providerID)")
            }
        }
        return providers
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}


//MARK: Sign In Email
extension AuthenticationManager {
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultDataModel {
        let authDataResults = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultDataModel(user: authDataResults.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultDataModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultDataModel(user: authDataResult.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updateEmail(to: email)
    }
}

//MARK: Sign In SSO
extension AuthenticationManager {
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultDataModel{
        let crediantial = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: crediantial)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResultDataModel{
       let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultDataModel(user: authDataResult.user)
    }
}
