//
//  TripUseCase.swift
//  TripWise
//
//  Created by Edoardo Pavan on 06/01/25.
//
import Dependencies

protocol TripUseCase {
    func submit(_ model: TripRequestModel) async throws -> TripRequestResponseModel
    func requestResult(requestId: String) async throws -> Trip
    func getAllTrip() throws -> [Trip]
}

struct TripLiveUseCase: TripUseCase {
    @Dependency(\.tripLocalRepository) private var tripLocalRepository
    @Dependency(\.tripRemoteRepository) private var remoteRepository
    
    @MainActor
    func submit(_ model: TripRequestModel) async throws -> TripRequestResponseModel {
        return try await remoteRepository.submit(TripRequestDataModel.from(model))
    }
    
    func requestResult(requestId: String) async throws -> Trip {
        let trip = try await remoteRepository.requestResult(requestId: requestId)
        try tripLocalRepository.saveTrip(trip)
        return trip
    }
    
    @MainActor
    func getAllTrip() throws -> [Trip] {
        try tripLocalRepository.getAllTrip()
    }
}
