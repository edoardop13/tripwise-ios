//
//  TripLocalRepository.swift
//  TripWise
//
//  Created by Edoardo Pavan on 28/01/25.
//

import Foundation
import Dependencies
import RealmSwift

protocol TripLocalRepository {
    func saveTrip (_ trip: Trip) throws
    func getAllTrip() throws -> [Trip]
}

struct TripLocalLiveRepository: TripLocalRepository {
    @Dependency(\.realmManager) private var realmManager
    
    @MainActor
    func saveTrip(_ trip: Trip) throws {
        let entity = TripEntity.from(trip)
        entity.generatedAt = Date()
        try realmManager.write(object: entity)
    }
    
    @MainActor
    func getAllTrip() throws -> [Trip] {
        let entities: Results<TripEntity> = realmManager.getObjectsList()
        return entities.map { $0.toModel() }
    }
    
}
