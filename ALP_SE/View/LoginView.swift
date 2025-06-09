//
//  LoginView.swift
//  ALP_SE
//
//  Created by Christianto Elvern Haryanto on 27/05/25.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var context
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    @EnvironmentObject var sessionController: SessionViewModel
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .bold()

                TextField("Username", text: $username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                Button("Login") {
                    guard !username.isEmpty && !password.isEmpty else {
                        alertMessage = "Please enter both username and password."
                        showAlert = true
                        return
                    }

                    do {
                        if let user = try userViewModel.login(username: username, password: password) {
                            sessionController.login(user: user)
                            alertMessage = "Login successful! with username: \(user.username)"
                            
                        } else {
                            alertMessage = "Login failed: Invalid username or password"
                        }
                    } catch {
                        alertMessage = "Login failed: \(error.localizedDescription)"
                    }
                    showAlert = true
                }
                .buttonStyle(.borderedProminent)
                .alert(alertMessage, isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }

                HStack {
                    Text("Don't have an account?")
                    NavigationLink("Register") {
                        RegisterView()
                    }
                    .foregroundColor(.blue)
                    .bold()
                }
                .font(.footnote)
                .padding(.top, 10)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: UserModel.self)
    let userViewModel = UserViewModel(context: container.mainContext)
    let session = SessionViewModel()

    LoginView()
        .environmentObject(userViewModel)
        .environmentObject(session)
        .modelContainer(container)
}
