//
//  ForgetPasswordView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 19/10/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    let coordinator: AuthCoordinator
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    @State private var showSuccess: Bool = false

    var body: some View {
        ZStack {
            AppColors.bgPrimary.edgesIgnoringSafeArea(.all)

            VStack(spacing: .spacing24) {
                // Header
                VStack(spacing: .spacing8) {
                    Image(systemName: "lock.shield")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.primaryGreen)

                    Text("Forgot Password?")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Enter your email to receive reset instructions")
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, .padding32)
                }
                .padding(.top, .padding64)

                // Email Input
                VStack(spacing: .spacing16) {
                    TextFieldView(
                        text: $email,
                        placeholder: "Email",
                        iconName: "envelope.fill",
                        keyboardType: .emailAddress
                    )

                    ButtonView(
                        title: isLoading ? "Sending..." : "Send Reset Link",
                        shadowColor: AppColors.primaryGreen.opacity(.opacityMedium),
                        action: {
                            sendResetLink()
                        }
                    )
                    .disabled(isLoading || email.isEmpty)
                    .opacity((isLoading || email.isEmpty) ? 0.6 : 1.0)

                    // Back to Login
                    Button(action: {
                        coordinator.backToLogin()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.left")
                            Text("Back to Login")
                        }
                        .font(.subheadline)
                        .foregroundColor(AppColors.primaryGreen)
                    }
                }
                .padding(.horizontal, .padding32)

                Spacer()
            }
        }
        .alert("Success", isPresented: $showSuccess) {
            Button("OK") {
                coordinator.backToLogin()
            }
        } message: {
            Text("Password reset link has been sent to \(email)")
        }
    }

    private func sendResetLink() {
        isLoading = true

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            showSuccess = true
        }
    }
}

#Preview {
    let appState = AppState()
    let coordinator = AuthCoordinator(router: appState.router, appState: appState)
    return ForgotPasswordView(coordinator: coordinator)
}
