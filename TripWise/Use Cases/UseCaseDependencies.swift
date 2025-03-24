//
//  UseCaseRepositories.swift
//  TripWise
//
//  Created by Edoardo Pavan on 06/01/25.
//

import Dependencies
import Foundation

enum TripUseCaseDependencyKey: DependencyKey {
    static var liveValue: TripUseCase {
        return TripLiveUseCase()
    }
}

extension DependencyValues {
    var tripUseCase: TripUseCase {
        get { self[TripUseCaseDependencyKey.self] }
        set { self[TripUseCaseDependencyKey.self] = newValue }
    }
}
