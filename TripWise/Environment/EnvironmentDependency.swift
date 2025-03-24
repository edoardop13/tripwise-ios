//
//  EnvironmentDependency.swift
//  VirtualVIP
//
//  Created by Marija Nenadic on 20.11.2023.
//

import Dependencies
import Foundation

enum EnvironmentDependencyKey: DependencyKey {
    static var liveValue: EnvironmentAPI {
        return DebugEnvironment()
    }
}

extension DependencyValues {
    var environment: EnvironmentAPI {
        get { self[EnvironmentDependencyKey.self] }
        set { self[EnvironmentDependencyKey.self] = newValue }
    }
}
