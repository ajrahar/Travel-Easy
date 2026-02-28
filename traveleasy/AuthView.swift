// AuthView.swift
// traveleasy
// Created by Assistant

import SwiftUI

private extension View {
    func authFieldStyle() -> some View {
        self
            .padding(.horizontal, Layout.Spacing.relaxed)
            .frame(height: Layout.Auth.fieldHeight)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: Layout.CornerRadius.medium, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: Layout.CornerRadius.medium, style: .continuous).strokeBorder(Color(.separator), lineWidth: 1))
    }
}

struct AuthView: View {
    @Binding var isAuthenticated: Bool
    @ScaledMetric(relativeTo: .title) private var authIconSize: CGFloat = 64
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var showPassword: Bool = false
    @State private var isLoading: Bool = false
    @State private var showSignUpSuccess = false
    @State private var signInErrorMessage: String = ""
    @State private var showSignInError: Bool = false
    @FocusState private var focusedField: Field?
    
    @AppStorage(AppStorageKeys.isAuthenticated) private var persistedIsAuthenticated: Bool = false
    @AppStorage(AppStorageKeys.storedEmail) private var storedEmail: String = ""
    @AppStorage(AppStorageKeys.storedPassword) private var storedPassword: String = ""
    @AppStorage(AppStorageKeys.storedName) private var storedName: String = ""
    @State private var mode: Mode = .signIn
    @State private var showForgotSheet = false

    enum Field { case email, password }
    enum Mode { case signIn, signUp }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "airplane.circle.fill")
                        .font(.system(size: authIconSize))
                        .foregroundStyle(.tint)
                    Text(L10n.welcomeTitle)
                        .font(.title2.bold())
                }
                .padding(.top, 24)

                VStack(spacing: 12) {
                    Picker("Mode", selection: $mode) {
                        Text(L10n.signIn).tag(Mode.signIn)
                        Text(L10n.signUp).tag(Mode.signUp)
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
                            .authFieldStyle()
                    }

                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusedField, equals: .email)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .password }
                        .authFieldStyle()

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
                        .padding(.leading, Layout.Spacing.relaxed)

                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundStyle(.tint)
                                .padding(.horizontal, Layout.Spacing.normal)
                                .padding(.vertical, 10)
                        }
                        .accessibilityLabel(showPassword ? "Hide password" : "Show password")
                        .accessibilityHint("Double tap to toggle password visibility")
                    }
                    .authFieldStyle()
                }

                Button(action: primaryAction) {
                    HStack {
                        if isLoading { ProgressView().tint(.white) }
                        Text(isLoading ? (mode == .signIn ? "Signing In…" : "Creating Account…") : (mode == .signIn ? L10n.signIn : L10n.createAccount))
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor, in: RoundedRectangle(cornerRadius: Layout.CornerRadius.medium, style: .continuous))
                    .foregroundStyle(.white)
                }
                .disabled(isLoading || email.isEmpty || password.isEmpty || (mode == .signUp && name.isEmpty))
                .accessibilityLabel(mode == .signIn ? L10n.signIn : L10n.createAccount)
                .accessibilityHint("Double tap to submit")

                HStack(spacing: 16) {
                    Button(L10n.forgotPassword) { showForgotSheet = true }
                        .accessibilityHint("Double tap to open password reset")
                    Button(mode == .signIn ? L10n.createAnAccount : L10n.haveAccountSignIn) {
                        withAnimation { mode = (mode == .signIn ? .signUp : .signIn) }
                    }
                    .accessibilityHint("Double tap to switch to \(mode == .signIn ? "sign up" : "sign in")")
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
            .navigationTitle(mode == .signIn ? L10n.signIn : L10n.signUp)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { focusedField = nil }
                        .accessibilityLabel("Done")
                        .accessibilityHint("Dismiss keyboard")
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
    @State private var isSending = false
    @State private var sendError: String?

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
                        .disabled(isSending)
                }
                if isSending {
                    Section {
                        HStack {
                            ProgressView()
                            Text("Sending…")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                if let error = sendError {
                    Section {
                        Text(error)
                            .foregroundStyle(.red)
                    }
                }
                if !message.isEmpty && !isSending {
                    Section { Text(message).foregroundStyle(.secondary) }
                }
            }
            .navigationTitle("Forgot Password")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .disabled(isSending)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send Link") {
                        sendResetLink()
                    }
                    .disabled(isSending || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func sendResetLink() {
        sendError = nil
        isSending = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            message = "If an account exists for \(email), a reset link has been sent."
            isSending = false
        }
    }
}

#Preview {
    StatefulPreviewWrapper(false) { isAuthed in
        AuthView(isAuthenticated: isAuthed)
    }
}

