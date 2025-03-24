//
//  Environment.swift
//  VirtualVIP
//
//  Created by Marija Nenadic on 20.11.2023.
//

import Foundation

protocol EnvironmentAPI {
    var baseUrl: URL { get }
}

struct DebugEnvironment: EnvironmentAPI {
    let baseUrlPath: String = "https://306do97eca.execute-api.eu-central-1.amazonaws.com"

    var baseUrl: URL {
        return URL(string: baseUrlPath)!
    }
}
