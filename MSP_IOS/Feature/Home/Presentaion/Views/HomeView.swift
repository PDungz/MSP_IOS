//
//  HomeView.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 16/10/25.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var router: Router
    @ObservedObject var appState: AppState

    var body: some View {
        Text("Home View")
    }
}

#Preview {
    HomeView(router: Router(), appState: AppState())
}
