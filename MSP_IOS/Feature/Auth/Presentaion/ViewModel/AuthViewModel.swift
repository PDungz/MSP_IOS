//
//  AuthViewModel.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 19/10/25.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func login() async -> Bool {
        isLoading = true
        errorMessage = nil

        try? await Task.sleep(nanoseconds: 1_500_000_000)

        if username == "admin" && password == "admin" {
            isLoading = false
            return true
        } else {
            isLoading = false
            errorMessage = "Invalid username or password"
            return false
        }
    }
}
