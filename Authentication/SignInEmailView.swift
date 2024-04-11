//
//  SignInEmailView.swift
//  NutriMind
//
//  Created by Preeten Dali on 10/01/24.
//

import SwiftUI

final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No password or email found.")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
    }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No password or email found.")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}

struct SignInEmailView: View {

    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack{
            Image("logo_transparent")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.bottom, 10)
            TextField("Email", text: $viewModel.email)
                .padding()
                .textInputAutocapitalization(.never)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            Button {
                Task{
                    do{
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print("Error")
                    }
                    
                    do{
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print("Error")
                    }
                }
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()

        }
        .padding()
        .navigationTitle("Sign In / Sign Up")
    }
}

struct SignInEmailView_Preview: PreviewProvider{
    static var previews: some View{
        NavigationStack{
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}

