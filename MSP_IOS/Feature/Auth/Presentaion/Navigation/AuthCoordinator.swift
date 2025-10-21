//
//  AuthCoordinator.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 19/10/25.
//

import SwiftUI

final class AuthCoordinator: BaseCoordinator<AuthRoute> {

    let appState: AppState

    init(router: Router, appState: AppState) {
        self.appState = appState
        super.init(router: router)
    }

    override func buildView(for route: AuthRoute) -> AnyView {
        switch route {
        case .login:
            return AnyView(LoginView(coordinator: self, appState: appState))

        case .forgotPassword:
            return AnyView(ForgotPasswordView(coordinator: self))
        case .signUp:
            return AnyView(SignUpView(coordinator: self))
        }
    }

    // MARK: - Navigation Methods
    func showForgotPassword() {
        print("🔵 Coordinator: Navigate to Forgot Password")
        navigate(to: .forgotPassword)
    }

    func backToLogin() {
        print("🔵 Coordinator: Back to Login")
        pop()
    }
}
