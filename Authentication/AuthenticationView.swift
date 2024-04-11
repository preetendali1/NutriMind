//
//  AuthenticationView.swift
//  NutriMind
//
//  Created by Preeten Dali on 10/01/24.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth


struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    func signInGoogle() async throws {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
    }
}

struct AuthenticationView: View {
  @StateObject private var viewModel = AuthenticationViewModel()
  @Binding var showSignInView: Bool
  @State private var isLoading = false

  var body: some View {
    VStack {
      Image("logo_transparent")
        .resizable()
        .frame(width: 150, height: 150)
        .padding(.bottom, 10)

      Spacer()

      NavigationLink {
        SignInEmailView(showSignInView: $showSignInView)
      } label: {
        Text("Sign In / Sign Up with Email")
          .font(.headline)
          .foregroundColor(.white)
          .frame(height: 55)
          .frame(maxWidth: .infinity)
          .background(Color.blue)
          .cornerRadius(10)
      }

      if isLoading {
        ProgressView()
          .frame(height: 55)
          .frame(maxWidth: .infinity)
          .background(Color.blue)
          .cornerRadius(10)
      } else {
        GoogleSignInButton(
          viewModel: GoogleSignInButtonViewModel(
            scheme: .dark,
            style: .wide,
            state: .normal
          )
        ) {
          isLoading = true
          Task {
            do {
              try await viewModel.signInGoogle()
              showSignInView = false
            } catch {
              print(error)
            }
              do { isLoading = false }
          }
        }
        .frame(width: 270, height: 55)
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(10)
      }

      Spacer()
    }
    .padding()
    .navigationTitle("NutriMind")
  }
}



struct AuthenticationView_Preview: PreviewProvider{
    static var previews: some View{
        NavigationStack{
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
