//
//  SignUpView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 19/10/25.
//

import SwiftUI

struct SignUpView: View {

    var body: some View {
        ZStack {
            AppColors.bgPrimary.edgesIgnoringSafeArea(.all)
            // Header
            VStack {
                VStack(spacing: .spacing8) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.grabGreen)

                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Sign up to get started")
                        .font(.subheadline)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, .padding32)
                }
                .padding(.top, .padding64)

                Spacer()

                // Back to Login button
                Button(action: {
                    AppNavigation.pop()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.left")
                        Text("Back to Login")
                    }
                    .font(.subheadline)
                    .foregroundColor(AppColors.grabGreen)
                }
                .padding(.bottom, .padding32)
            }

        }

    }
}

#Preview {
    SignUpView()
}
