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
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        ZStack {
            AppColors.primaryGreen.edgesIgnoringSafeArea(.all)

            VStack {
                VStack(alignment: .leading, spacing: .spacing16) {
                    Image("grabText")
                        .resizable()
                        .scaledToFit()
                        .frame(height: .iconSize56)

                    VStack(alignment: .leading, spacing: .spacing4) {
                        Text("Your forever")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.black)

                        Text("people platform")
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
                        TextFiedView(
                            text: $authViewModel.username,
                            placeholder: "Username",
                            iconName: "person.fill",
                            keyboardType: .emailAddress
                        )
                        .padding(.bottom, .padding12)
                        .disabled(authViewModel.isLoading)

                        TextFiedView(
                            text: $authViewModel.password,
                            placeholder: "Password",
                            iconName: "lock.fill",
                            iconNameRight: isPasswordVisible ? "eye.slash.fill" : "eye.fill",
                            showClearButton: false,
                            isSecure: !isPasswordVisible,
                            onRightIconTapped: {
                                isPasswordVisible.toggle()
                            }
                        )
                        .padding(.bottom, .padding12)
                        .disabled(authViewModel.isLoading)

                        if let errorMessage = authViewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, .padding8)
                        }

                        Button(action: {
                            print("Navigate to forgot password")
                            coordinator.showForgotPassword()
                        }) {
                            Text("Forgot Password?")
                                .font(.subheadline)
                                .foregroundColor(AppColors.textSecondary)
                                .underline()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding(.bottom, .padding8)

                        ButtonView(
                            title: authViewModel.isLoading ? "Loading..." : "Login",
                            shadowColor: AppColors.primaryGreen.opacity(.opacityMedium),
                            action: {
                                Task {
                                    let success = await authViewModel.login()
                                    if success {
                                        appState.login()
                                    }
                                }
                            }
                        )
                        .disabled(authViewModel.isLoading)
                        .opacity(authViewModel.isLoading ? 0.6 : 1.0)
                        .padding(.bottom, .padding8)

                        Text("Or")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.bottom, .padding8)

                        ButtonView(
                            title: "Sign In Using Apple",
                            icon: .system("apple.logo"),
                            style: .outline,
                            action: {}
                        )
                        .padding(.bottom, .padding8)
                        .disabled(authViewModel.isLoading)

                        ButtonView(
                            title: "Sign In Using Google",
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
                            color: AppColors.black.opacity(.opacityDisabled),
                            radius: 20,
                            x: 0,
                            y: 8
                        )
                )
            }
            .ignoresSafeArea(edges: .bottom)

            // Loading overlay
            if authViewModel.isLoading {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)

                    Text("Logging in...")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    let appState = AppState()
    let coordinator = AuthCoordinator(router: appState.router, appState: appState)
    return LoginView(coordinator: coordinator, appState: appState)
}
