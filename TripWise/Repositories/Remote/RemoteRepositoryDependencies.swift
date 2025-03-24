//
//  RepositoryDependencies.swift
//  TripWise
//
//  Created by Edoardo Pavan on 06/01/25.
//

import Dependencies
import Foundation

enum TripRemoteRepositoryDependencyKey: DependencyKey {
    static var liveValue: TripRemoteRepository {
        return TripRemoteLiveRepository()
    }
}

extension DependencyValues {
    var tripRemoteRepository: TripRemoteRepository {
        get { self[TripRemoteRepositoryDependencyKey.self] }
        set { self[TripRemoteRepositoryDependencyKey.self] = newValue }
    }
}
