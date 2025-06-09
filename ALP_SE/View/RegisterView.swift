//
//  RegisterView.swift
//  ALP_SE
//
//  Created by Christianto Elvern Haryanto on 27/05/25.
//

import SwiftUI
import SwiftData

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToLogin = false
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        NavigationView {   // <-- Wrap content in NavigationView
            VStack(spacing: 20) {
                Text("Register")
                    .font(.largeTitle)
                    .bold()

                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)

                Button("Register") {
                    if username.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                        alertMessage = "Please fill out all fields."
                        showAlert = true
                    } else if password != confirmPassword {
                        alertMessage = "Passwords do not match."
                        showAlert = true
                    } else {
                        do {
                            let success = try userViewModel.register(username: username, password: password)
                            if success {
                                alertMessage = "Registration successful!"
                                showAlert = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    navigateToLogin = true
                                }
                            } else {
                                alertMessage = "Username already exists."
                                showAlert = true
                            }
                        } catch {
                            alertMessage = "Registration failed: \(error.localizedDescription)"
                            showAlert = true
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                .alert(alertMessage, isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }

                NavigationLink(destination: StartView(), isActive: $navigateToLogin) {
                    EmptyView()
                }
            }
            .padding()
            .navigationBarHidden(false) // Optional, if you want to hide nav bar here
        }
    }
}



#Preview {
    // Prepare a ModelContainer for UserModel
    let container = try! ModelContainer(for: UserModel.self)
    // Create UserController with container's context
    let userViewModel = UserViewModel(context: container.mainContext)

    RegisterView()
        .environmentObject(userViewModel)
        .modelContainer(container)
}
