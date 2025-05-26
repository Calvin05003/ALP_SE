//
//  LoginView.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var session: SessionController
    @State private var username = ""
    @State private var password = ""
    @State private var alertMessage = ""
    @State private var showAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Login").font(.largeTitle).bold()

            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Login") {
                Task {
                    let controller = UserController(context: context)
                    do {
                        if let user = try controller.login(username: username, password: password) {
                            session.login(user: user)
                        } else {
                            alertMessage = "Invalid credentials."
                            showAlert = true
                        }
                    } catch {
                        alertMessage = "Login failed."
                        showAlert = true
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            NavigationLink("Don't have an account? Register", destination: RegisterView())
                .font(.footnote)
        }
        .padding()
        .alert(alertMessage, isPresented: $showAlert) {}
    }
}



#Preview {
    LoginView()
        .modelContainer(for: UserModel.self, inMemory: true)
}
