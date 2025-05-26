//
//  RegisterView.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import SwiftUI
import SwiftData

struct RegisterView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var session: SessionController
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Register").font(.largeTitle).bold()

                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(.roundedBorder)

                Button("Register") {
                    Task {
                        guard password == confirmPassword else {
                            alertMessage = "Passwords do not match."
                            showAlert = true
                            return
                        }

                        let controller = UserController(context: context)
                        do {
                            let success = try controller.register(
                                userId: Int.random(in: 1000...9999),
                                username: username,
                                password: password
                            )
                            if success {
                                navigateToLogin = true
                            } else {
                                alertMessage = "Username already exists."
                                showAlert = true
                            }
                        } catch {
                            alertMessage = "Registration failed."
                            showAlert = true
                        }
                    }
                }
                .buttonStyle(.borderedProminent)

                NavigationLink("Already have an account? Login", destination: LoginView())
                    .font(.footnote)

                NavigationLink("", destination: LoginView(), isActive: $navigateToLogin)
                    .opacity(0)
            }
            .padding()
            .alert(alertMessage, isPresented: $showAlert) {}
        }
    }
}


#Preview {
    RegisterView()
        .modelContainer(for: UserModel.self, inMemory: true)
}
