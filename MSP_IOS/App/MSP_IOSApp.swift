//
//  MSP_IOSApp.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 16/10/25.
//

import SwiftUI

@main
struct MSP_IOSApp: App {

    //MARK: - State

    // Global app state
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .onAppear {

                }
        }
    }


    private func setupApp() {
        print("MSP IOS App Setup")
    }
}
