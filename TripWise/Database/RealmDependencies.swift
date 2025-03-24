//
//  TripRemoteRepositoryDependencyKey.swift
//  TripWise
//
//  Created by Edoardo Pavan on 28/01/25.
//

import Dependencies
import Foundation

enum RealmManagerDependencyKey: DependencyKey {
    static let liveValue: RealmLiveManager = .realmManager

    static let testValue: RealmLiveManager = .realmManager
}

extension DependencyValues {
    @MainActor
    var realmManager: RealmLiveManager {
        get { self[RealmManagerDependencyKey.self] }
        set { self[RealmManagerDependencyKey.self] = newValue }
    }
}
