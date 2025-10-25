//
//  Login.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 16/10/25.
//

import SwiftUI

struct LoginView: View {
    let coordinator: AuthCoordinator
    @ObservedObject var appState: AppState
    @State private var isPasswordVisible = false

    // ✅ Inject AuthService from AppState
    @StateObject private var authViewModel: AuthViewModel

    init(coordinator: AuthCoordinator, appState: AppState) {
        self.coordinator = coordinator
        self.appState = appState

        // ✅ Initialize ViewModel with AuthService from AppState
        _authViewModel = StateObject(wrappedValue: AuthViewModel(authService: appState.auth))
    }

    var body: some View {
        ZStack {
            AppColors.grabGreen.edgesIgnoringSafeArea(.all)

            VStack {
                VStack(alignment: .leading, spacing: .spacing16) {
                    Image("grabText")
                        .resizable()
                        .scaledToFit()
                        .frame(height: .iconSize56)

                    VStack(alignment: .leading, spacing: .spacing4) {
                        Text(NSLocalizedString("login_your_forever", comment: "Header text"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)

                        Text(NSLocalizedString("login_people_platform", comment: "Header text"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)
                            .padding(.horizontal, .padding8)
                            .padding(.vertical, .padding4)
                            .background(AppColors.bgPrimary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, .padding36)
                .padding(.horizontal, .padding32)
                .padding(.bottom, .padding32)

                Spacer()

                VStack {
                    VStack {
                        TextFieldView(
                            text: $authViewModel.username,
                            placeholder: NSLocalizedString("login_username", comment: "Username placeholder"),
                            leftIcon: .system("person.fill"),
                            keyboardType: .emailAddress
                        )
                        .padding(.bottom, .padding12)
                        .disabled(authViewModel.isLoading)

                        TextFieldView(
                            text: $authViewModel.password,
                            placeholder: NSLocalizedString("login_password", comment: "Password placeholder"),
                            leftIcon: .system("lock.fill"),
                            rightIcon: .icon(.system(isPasswordVisible ? "eye.slash.fill" : "eye.fill")),
                            showClearButton: false,
                            isSecure: !isPasswordVisible,
                            onRightIconTapped: {
                                isPasswordVisible.toggle()
                            }
                        )
                        .padding(.bottom, .padding12)
                        .disabled(authViewModel.isLoading)

                        // ✅ Error Message
                        if let errorMessage = authViewModel.errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, .padding8)
                            .padding(.horizontal, .padding12)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.bottom, .padding8)
                        }

                        // ✅ Success Message
                        if let successMessage = authViewModel.successMessage {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(successMessage)
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, .padding8)
                            .padding(.horizontal, .padding12)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.bottom, .padding8)
                        }

                        Button(action: {
                            coordinator.showForgotPassword()
                        }) {
                            Text(NSLocalizedString("login_forgot_password", comment: "Forgot password button"))
                                .font(.subheadline)
                                .foregroundColor(AppColors.textSecondary)
                                .underline()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.bottom, .padding8)

                        // ✅ Login Button
                        ButtonView(
                            title: authViewModel.isLoading ?
                                NSLocalizedString("login_loading_message", comment: "Loading message") :
                                NSLocalizedString("login", comment: "Login button"),
                            shadowColor: AppColors.grabGreen.opacity(.opacity3),
                            action: {
                                Task {
                                    // ✅ Call login - AppState will auto sync from AuthService
                                    let success = await authViewModel.login()

                                    if success {
                                        // ✅ KHÔNG CẦN gọi appState.login() nữa
                                        // AuthService.isAuthenticated changed → AppState syncs automatically
                                        AppLogger.s("Login successful, waiting for auto navigation...")
                                    }
                                }
                            }
                        )
                        .disabled(authViewModel.isLoading)
                        .opacity(authViewModel.isLoading ? 0.6 : 1.0)
                        .padding(.bottom, .padding8)

                        HStack {
                            Text(
                                NSLocalizedString(
                                    "login_need_to_create_an_account",
                                    comment: ""
                                )
                            )
                            .font(.subheadline)
                            .fontWeight(.bold)

                            Button(action: {
                                coordinator.showForgotPassword()
                            }) {
                                Text(NSLocalizedString("login_sign_up", comment: ""))
                                    .font(.subheadline)
                                    .foregroundColor(AppColors.textSecondary)
                                    .underline()
                            }
                        }

                        ButtonView(
                            title: NSLocalizedString("login_sign_in_using_apple", comment: "Sign in with Apple"),
                            icon: .system("apple.logo"),
                            style: .outline,
                            action: {}
                        )
                        .padding(.bottom, .padding8)
                        .disabled(authViewModel.isLoading)

                        ButtonView(
                            title: NSLocalizedString("login_sign_in_using_google", comment: "Sign in with Google"),
                            icon: .asset("google"),
                            style: .outline,
                            action: {}
                        )
                        .disabled(authViewModel.isLoading)
                    }
                    Spacer()
                }
                .padding(.top, .padding20)
                .padding(.horizontal, .padding32)
                .padding(.vertical, .padding32)
                .frame(maxWidth: .infinity, alignment: .bottom)
                .background(
                    RoundedRectangle(cornerRadius: .radius24)
                        .fill(AppColors.bgPrimary)
                        .shadow(
                            color: AppColors.black.opacity(.opacity4),
                            radius: 20,
                            x: 0,
                            y: 8
                        )
                )
            }
            .ignoresSafeArea(edges: .bottom)

            // ✅ Loading Overlay
            if authViewModel.isLoading {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)

                    Text(NSLocalizedString("login_loading_message", comment: "Loading message"))
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            // ✅ Check auth on appear (will auto navigate if already logged in)
            authViewModel.checkAuthStatus()
        }
    }
}

#Preview {
    let appState = AppState()
    let coordinator = AuthCoordinator(router: appState.router, appState: appState)
    return LoginView(coordinator: coordinator, appState: appState)
}
