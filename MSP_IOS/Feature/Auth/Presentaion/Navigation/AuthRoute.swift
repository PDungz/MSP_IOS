//
//  AuthRoute.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 19/10/25.
//

import Foundation

enum AuthRoute: Route {
    case login
    case forgotPassword
    case signUp

    var id: String {
        switch self {
        case .login: return "login"
        case .forgotPassword: return "forgotPassword"
        case .signUp: return "signUp"
        }
    }
}
