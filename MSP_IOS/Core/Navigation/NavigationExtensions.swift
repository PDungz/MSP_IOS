//
//  NavigationExtensions.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI

// Environment key cho Router (nếu cần inject vào environment)
struct RouterEnvironmentKey: EnvironmentKey {
    static let defaultValue: Router? = nil
}

extension EnvironmentValues {
    var router: Router? {
        get { self[RouterEnvironmentKey.self] }
        set { self[RouterEnvironmentKey.self] = newValue }
    }
}

extension View {
    func withRouter(_ router: Router) -> some View {
        self.environment(\.router, router)
    }
}
