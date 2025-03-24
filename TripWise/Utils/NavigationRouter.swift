//
//  Router.swift
//  VirtualVIP
//
//  Created by Edoardo Pavan on 07/11/24.
//

import SwiftUI

@Observable
class NavigationRouter<S: Hashable> {
    var navigationPath: [S]

    init(navigationPath: [S] = []) {
        self.navigationPath = navigationPath
    }

    func navigateBack() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }

    func navigate(to screen: S) {
        navigationPath.append(screen)
    }
}
