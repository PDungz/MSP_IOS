//
//  SignUpView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 19/10/25.
//

import SwiftUI

struct SignUpView: View {

    let coordinator: AuthCoordinator

    var body: some View {
        ZStack {
            AppColors.bgPrimary.edgesIgnoringSafeArea(.all)
            // Header
            VStack {
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


                Spacer()
            }

        }

    }
}

#Preview {
    let appState = AppState()
    let coordinator = AuthCoordinator(router: appState.router, appState: appState)
    SignUpView(coordinator: coordinator)
}
