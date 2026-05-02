//
//  NavigationRoute.swift
//  GalleryApp
//
//  Created by Rahul Kiumar on 02/05/26.
//

import Foundation
import SwiftUI

struct AnyScreen: Hashable {
    private let id = UUID()
    private let viewBuilder: () -> AnyView
    
    init<V: View>(_ view: V) {
        self.viewBuilder = { AnyView(view) }
    }
    
    func build() -> AnyView {
        viewBuilder()
    }
    
    static func == (lhs: AnyScreen, rhs: AnyScreen) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Observable
final class NavigationRoute {
    var path: NavigationPath = .init()
    
    func push(_ screen: AnyScreen) {
        path.append(screen)
    }
    
    func pop() {
        if path.count > 0 {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = .init()
    }
}
