//
// SettingsView.swift
// NutriMind
//
// Created by Preeten Dali on 10/01/24.
//


import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @Binding var showSignInView: Bool

    init(showSignInView: Binding<Bool>) {
        self._showSignInView = showSignInView
        self._viewModel = StateObject(wrappedValue: SettingsViewModel(showSignInView: showSignInView))
    }

    var body: some View {
        NavigationView {
            List {
                HStack {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .foregroundColor(.gray)

                    VStack(alignment: .leading) {
                        Text("preetendali")
                            .font(.headline)
                        Text("preetendali@gmail.com")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding(16)

                Button("Sign Out") {
                    Task {
                        do {
                            try await viewModel.signOut()
                        } catch {
                            print(error)
                        }
                    }
                }

                Button("Reset Password") {
                    Task {
                        do {
                            try await viewModel.resetPassword()
                            print("Password Reset")
                        } catch {
                            print(error)
                        }
                    }
                }

                Button("Update Email") {
                    Task {
                        do {
                            try await viewModel.updateEmail()
                            print("Email Update")
                        } catch {
                            print(error)
                        }
                    }
                }

                Button("Delete Account") {
                    Task {
                        do {
                            try await viewModel.signOut()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

// Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignInView: .constant(false))
    }
}
