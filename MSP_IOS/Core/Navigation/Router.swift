//
//  Router.swift
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

import SwiftUI

// MARK: - Route Protocol
protocol Route: Hashable, Identifiable {
    var id: String { get }
}

extension Route {
    var id: String { String(describing: self) }
}

// MARK: - Router
final class Router: ObservableObject {
    @Published var path = [AnyHashable]()
    @Published var presentedSheet: AnyHashable?
    @Published var presentedFullScreen: AnyHashable?

    init() {
        print("🟢 Router.init: Created new router \(ObjectIdentifier(self))")
    }

    func push<T: Route>(_ route: T) {
        print("🟢 Router.push: Pushing \(route)")
        print("🟢 Before push - Path count: \(path.count)")
        path.append(AnyHashable(route))
        print("🟢 After push - Path count: \(path.count)")
    }

    func pop() {
        guard !path.isEmpty else {
            print("🔴 Router.pop: Path is empty!")
            return
        }
        print("🟡 Router.pop: Popping from path")
        path.removeLast()
        print("🟡 After pop - Path count: \(path.count)")
    }

    func popToRoot() {
        print("🟡 Router.popToRoot: Clearing all paths")
        path.removeAll()
    }

    func presentSheet<T: Route>(_ route: T) {
        presentedSheet = AnyHashable(route)
    }

    func dismissSheet() {
        presentedSheet = nil
    }

    func presentFullScreen<T: Route>(_ route: T) {
        presentedFullScreen = AnyHashable(route)
    }

    func dismissFullScreen() {
        presentedFullScreen = nil
    }

    func clear() {
        path.removeAll()
        presentedSheet = nil
        presentedFullScreen = nil
    }
}
