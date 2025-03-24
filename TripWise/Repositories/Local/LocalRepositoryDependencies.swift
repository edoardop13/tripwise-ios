//
//  TripRemoteRepositoryDependencyKey.swift
//  TripWise
//
//  Created by Edoardo Pavan on 28/01/25.
//


import Dependencies
import Foundation

enum TripLocalRepositoryDependencyKey: DependencyKey {
    static var liveValue: TripLocalRepository {
        return TripLocalLiveRepository()
    }
}

extension DependencyValues {
    var tripLocalRepository: TripLocalRepository {
        get { self[TripLocalRepositoryDependencyKey.self] }
        set { self[TripLocalRepositoryDependencyKey.self] = newValue }
    }
}
