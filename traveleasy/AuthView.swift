// AuthView.swift
// traveleasy
// Created by Assistant

import SwiftUI

struct AuthView: View {
    @Binding var isAuthenticated: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @FocusState private var focusedField: Field?

    enum Field { case email, password }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "airplane.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.tint)
                    Text("Welcome to TravelEasy")
                        .font(.title2.bold())
                }
                .padding(.top, 24)

                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .password }
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .focused($focusedField, equals: .password)
                        .submitLabel(.go)
                        .onSubmit(signIn)
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }

                Button(action: signIn) {
                    HStack {
                        if isLoading { ProgressView().tint(.white) }
                        Text(isLoading ? "Signing In…" : "Sign In")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .foregroundStyle(.white)
                }
                .disabled(isLoading || email.isEmpty || password.isEmpty)

                Button("Create an account") {
                    // Placeholder for sign-up flow
                }
                .buttonStyle(.borderless)
                .padding(.top, -8)

                Spacer()
            }
            .padding()
            .navigationTitle("Sign In")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focusedField = nil }
                }
            }
            .background(
                LinearGradient(colors: [Color(.systemBackground), Color(.secondarySystemBackground)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
    }

    private func signIn() {
        guard !email.isEmpty, !password.isEmpty else { return }
        isLoading = true
        // Simulate network auth
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeInOut) {
                isAuthenticated = true
                isLoading = false
            }
        }
    }
}

#Preview {
    StatefulPreviewWrapper(false) { isAuthed in
        AuthView(isAuthenticated: isAuthed)
    }
}
