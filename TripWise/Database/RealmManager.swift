//
//  TripRemoteRepositoryDependencyKey.swift
//  TripWise
//
//  Created by Edoardo Pavan on 28/01/25.
//

import Dependencies
import Foundation
import RealmSwift

protocol RealmManager {
    func write<E>(object: E) throws where E: Object
    func getObject<E>(forPrimaryKey: Int) throws -> E where E: Object
    func deleteObject<E>(_ object: E) throws where E: Object
    func getObjectsList<E>() -> Results<E> where E: Object
}

struct RealmLiveManager: RealmManager {
    static let schemaVersion: UInt64 = 5
    private let realm: Realm

    @MainActor
    func write<E>(object: E) throws where E: Object {
        try realm.write {
            realm.add(object, update: .modified)
        }
    }

    @MainActor
    func getObject<E, K>(forPrimaryKey: K) throws -> E where E: Object {
        guard let object = realm.object(ofType: E.self, forPrimaryKey: forPrimaryKey) else {
            throw RealmManagerError.objectNotFound
        }
        return object
    }

    @MainActor
    func getObjectsList<E>() -> Results<E> where E: Object {
        return realm.objects(E.self)
    }

    @MainActor
    func deleteObject<E>(_ object: E) throws where E: Object {
        try realm.write {
            realm.delete(object)
        }
    }

    @MainActor
    func deleteAll<E>(objects: Results<E>) throws where E: Object {
        if !objects.isEmpty {
            try realm.write {
                for object in objects {
                    realm.delete(object)
                }
            }
        }
    }
}

extension RealmLiveManager {
    static var realmManager: RealmLiveManager = .init(realm: createRealmInstance())

    static private func createRealmInstance() -> Realm {
        var realm: Realm
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = schemaVersion
        do {
            realm = try Realm(configuration: config)
            return realm
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
}

enum RealmManagerError: Error {
    case objectNotFound
}
