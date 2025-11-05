//
//  MSP_IOSApp.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 16/10/25.
//

import SwiftUI

@main
struct MSP_IOSApp: App {

    // MARK: - State
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            // ✅ Use new centralized navigation system
            Group {
                if appState.isAuthenticated {
                    RootNavigationView(initialRoute: .home)
                } else {
                    RootNavigationView(initialRoute: .login)
                }
            }
            .preferredColorScheme(.light) // Force Light Mode - ignore system Dark Mode
            .onAppear {
                setupApp()
            }
        }
    }

    private func setupApp() {
        // ✅ Setup logger
        #if DEBUG
        AppLogger.isEnabled = true
        AppLogger.minLevel = .info
        #else
        AppLogger.isEnabled = false
        AppLogger.minLevel = .error
        #endif

        AppLogger.i("🚀 MSP iOS App launched")
    }
}
