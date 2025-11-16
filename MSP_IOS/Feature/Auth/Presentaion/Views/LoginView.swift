//
//  Login.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 16/10/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isPasswordVisible = false
    @State private var authViewModel: AuthViewModel?

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

                if let viewModel = authViewModel {
                    VStack {
                        VStack {
                            TextFieldView(
                                text: Binding(
                                    get: { viewModel.username },
                                    set: { viewModel.username = $0 }
                                ),
                                placeholder: NSLocalizedString("login_username", comment: "Username placeholder"),
                                leftIcon: .system("person.fill"),
                                keyboardType: .emailAddress
                            )
                            .padding(.bottom, .padding12)
                            .disabled(viewModel.isLoading)

                            TextFieldView(
                                text: Binding(
                                    get: { viewModel.password },
                                    set: { viewModel.password = $0 }
                                ),
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
                            .disabled(viewModel.isLoading)

                            // ✅ Error Message
                            if let errorMessage = viewModel.errorMessage {
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
                            if let successMessage = viewModel.successMessage {
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
                                AppNavigation.push(.forgotPassword)
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
                                title: viewModel.isLoading ?
                                    NSLocalizedString("login_loading_message", comment: "Loading message") :
                                    NSLocalizedString("login", comment: "Login button"),
                                shadowColor: AppColors.grabGreen.opacity(.opacity3),
                                action: {
                                    Task {
                                        // ✅ Call login - AppState will auto sync from AuthService
                                        let success = await viewModel.login()

                                        if success {
                                            // ✅ Navigation handled automatically by AppState observer
                                            AppLogger.s("Login successful, waiting for auto navigation...")
                                        }
                                    }
                                }
                            )
                            .disabled(viewModel.isLoading)
                            .opacity(viewModel.isLoading ? 0.6 : 1.0)
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
                                    AppNavigation.push(.register)
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
                            .disabled(viewModel.isLoading)

                            ButtonView(
                                title: NSLocalizedString("login_sign_in_using_google", comment: "Sign in with Google"),
                                icon: .asset("google"),
                                style: .outline,
                                action: {}
                            )
                            .disabled(viewModel.isLoading)
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

                    // ✅ Loading Overlay
                    if viewModel.isLoading {
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
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            // ✅ Initialize authViewModel with AppState.auth
            // AppState is now guaranteed to be available from environment
            if authViewModel == nil {
                authViewModel = AuthViewModel(authService: appState.auth)
                authViewModel?.checkAuthStatus()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
