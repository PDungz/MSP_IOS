//
//  StorageKeys.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 21/10/25.
//

import Foundation

struct StorageKeys {
    struct Auth {
        static let jwtToken = "secure.auth.jwt_token"
        static let refreshToken = "secure.auth.refresh_token"
        static let userData = "secure.auth.user_data"
        static let tokenExpiration = "secure.auth.token_expiration"
    }
}
