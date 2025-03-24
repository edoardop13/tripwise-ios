//
//  HistoryViewModel.swift
//  TripWise
//
//  Created by Edoardo Pavan on 29/01/25.
//

import Foundation
import Dependencies

@Observable
class HistoryViewModel {
    @ObservationIgnored @Dependency(\.tripUseCase) private var tripUseCase
    var groupedTrips: [(String, [Trip])] = []
    
    @MainActor
    func loadTrips() async {
        do {
            let trips: [Trip] = try tripUseCase.getAllTrip()
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            
            let sortedTrips = trips.sorted { ($0.generatedAt ?? Date()) > ($1.generatedAt ?? Date()) }
            let grouped = Dictionary(grouping: sortedTrips) { formatter.string(from: $0.generatedAt ?? Date()) }
            groupedTrips = grouped.sorted { $0.0 > $1.0 }
        } catch {
            print("Cannot load trips: \(error)")
        }
    }
    
}
