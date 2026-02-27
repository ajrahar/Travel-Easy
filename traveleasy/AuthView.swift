// AuthView.swift
// traveleasy
// Created by Assistant

import SwiftUI

struct AuthView: View {
    @Binding var isAuthenticated: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var showPassword: Bool = false
    @State private var isLoading: Bool = false
    @State private var showSignUpSuccess = false
    @State private var signInErrorMessage: String = ""
    @State private var showSignInError: Bool = false
    @FocusState private var focusedField: Field?
    
    @AppStorage("isAuthenticated") private var persistedIsAuthenticated: Bool = false
    @AppStorage("storedEmail") private var storedEmail: String = ""
    @AppStorage("storedPassword") private var storedPassword: String = ""
    @AppStorage("storedName") private var storedName: String = ""
    @State private var mode: Mode = .signIn
    @State private var showForgotSheet = false

    enum Field { case email, password }
    enum Mode { case signIn, signUp }

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

                VStack(spacing: 12) {
                    Picker("Mode", selection: $mode) {
                        Text("Sign In").tag(Mode.signIn)
                        Text("Sign Up").tag(Mode.signUp)
                    }
                    .pickerStyle(.segmented)

                    if mode == .signUp {
                        TextField("Full name", text: $name)
                            .textContentType(.name)
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled(false)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .email }
                            .padding()
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

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

                    HStack(spacing: 0) {
                        Group {
                            if showPassword {
                                TextField(mode == .signIn ? "Password" : "Create a password", text: $password)
                                    .textContentType(.password)
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.go)
                                    .onSubmit(primaryAction)
                            } else {
                                SecureField(mode == .signIn ? "Password" : "Create a password", text: $password)
                                    .textContentType(.password)
                                    .focused($focusedField, equals: .password)
                                    .submitLabel(.go)
                                    .onSubmit(primaryAction)
                            }
                        }
                        .padding(.leading)

                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.thinMaterial)
                    )
                }

                Button(action: primaryAction) {
                    HStack {
                        if isLoading { ProgressView().tint(.white) }
                        Text(isLoading ? (mode == .signIn ? "Signing In…" : "Creating Account…") : (mode == .signIn ? "Sign In" : "Create Account"))
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .foregroundStyle(.white)
                }
                .disabled(isLoading || email.isEmpty || password.isEmpty || (mode == .signUp && name.isEmpty))

                HStack(spacing: 16) {
                    Button("Forgot Password?") { showForgotSheet = true }
                    Button(mode == .signIn ? "Create an account" : "Have an account? Sign In") {
                        withAnimation { mode = (mode == .signIn ? .signUp : .signIn) }
                    }
                }
                .buttonStyle(.borderless)
                .padding(.top, -8)
                .sheet(isPresented: $showForgotSheet) {
                    ForgotPasswordView(storedEmail: storedEmail)
                }
                .alert("Account created!", isPresented: $showSignUpSuccess) {
                    Button("OK") {
                        withAnimation {
                            mode = .signIn
                            // Prefill email and move focus to password for quick sign-in
                            email = storedEmail
                            password = ""
                            focusedField = .password
                        }
                    }
                } message: {
                    Text("You can now sign in, \(name.split(separator: " ").first ?? Substring(""))")
                }
                .alert("Sign In Failed", isPresented: $showSignInError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(signInErrorMessage)
                }

                Spacer()
            }
            .padding()
            .navigationTitle(mode == .signIn ? "Sign In" : "Sign Up")
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

    private func primaryAction() { mode == .signIn ? signIn() : signUp() }

    private func signIn() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let hasStored = !storedEmail.isEmpty && !storedPassword.isEmpty
            let matches: Bool
            if hasStored {
                matches = (trimmedEmail.caseInsensitiveCompare(storedEmail) == .orderedSame) && (trimmedPassword == storedPassword)
            } else {
                matches = true
            }
            withAnimation(.easeInOut) {
                if matches {
                    // Normalize UI fields to stored values
                    email = storedEmail
                    password = ""
                    persistedIsAuthenticated = true
                    isAuthenticated = true
                } else {
                    signInErrorMessage = "Email or password is incorrect."
                    showSignInError = true
                }
                isLoading = false
            }
        }
    }

    private func signUp() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty, !trimmedName.isEmpty else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            storedName = trimmedName
            storedEmail = trimmedEmail
            storedPassword = trimmedPassword
            withAnimation(.easeInOut) {
                isLoading = false
                showSignUpSuccess = true
            }
        }
    }
}

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String
    @State private var message: String = ""

    init(storedEmail: String) {
        _email = State(initialValue: storedEmail)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Account Email")) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                if !message.isEmpty {
                    Section { Text(message).foregroundStyle(.secondary) }
                }
            }
            .navigationTitle("Forgot Password")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send Link") {
                        // Simulate sending a reset link
                        message = "If an account exists for \(email), a reset link has been sent."
                    }
                }
            }
        }
    }
}

#Preview {
    StatefulPreviewWrapper(false) { isAuthed in
        AuthView(isAuthenticated: isAuthed)
    }
}
