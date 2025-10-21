//
//  LoginAPIRequest.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 20/10/25.
//

import Foundation

struct LoginAPIRequest: APIEndpoint {
    let credentials: LoginRequest

    var path: String {
        return APIConfig.Endpoint.login.path
    }

    var method: HTTPMethod {
        return .post
    }

    var body: Data? {
        return try? JSONEncoder().encode(credentials)
    }
}
