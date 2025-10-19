//
//  AppState.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI

final class AppState: ObservableObject {

    @Published var isAuthenticated: Bool = false
    @Published var router: Router

    lazy var authCoordinator: AuthCoordinator = {
        AuthCoordinator(router: router, appState: self)
    }()

    init() {
        self.router = Router()
    }

    func login() {
        isAuthenticated = true
    }

    func logout() {
        isAuthenticated = false
        router.clear()
    }
}
