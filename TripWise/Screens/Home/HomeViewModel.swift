//
//  HomeViewModel.swift
//  TripWise
//
//  Created by Edoardo Pavan on 06/01/25.
//

import Combine
import Foundation
import Dependencies

struct TagViewItem {
    let title: String
    var isSelected: Bool = false
}

@Observable
class HomeViewModel {
    @ObservationIgnored @Dependency(\.tripUseCase) private var tripUseCase

    var activeStep: Int = 0
    var totalSteps: Int = 2
    var city: String = ""
    var month: [TagViewItem] = [
        TagViewItem(title: "January", isSelected: true),
        TagViewItem(title: "February"),
        TagViewItem(title: "March"),
        TagViewItem(title: "April"),
        TagViewItem(title: "May"),
        TagViewItem(title: "June"),
        TagViewItem(title: "July"),
        TagViewItem(title: "August"),
        TagViewItem(title: "September"),
        TagViewItem(title: "October"),
        TagViewItem(title: "November"),
        TagViewItem(title: "December")
    ]
    var days: Int = 1
    var people: Int = 1
    var withKids: Bool = false
    var generatedTrip: Trip?
    var loading: Bool = false
    var showTrip: Bool = false
    
    // Timer for polling
    private var cancellables: Set<AnyCancellable> = []
    private var timer: AnyCancellable?
    
    func submit() async {
        loading = true
        do {
            let model = TripRequestModel(
                city: city,
                month: month.first(where: { $0.isSelected == true })?.title ?? "January",
                days: days,
                people: people,
                withKids: withKids
            )
            let requestId = try await tripUseCase.submit(model).requestId
            startPolling(requestId: requestId)
        } catch {
            loading = false
            print("Submit error: \(error.localizedDescription)")
        }
    }
    
    private func startPolling(requestId: String) {
        timer = Timer.publish(every: 15.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                fetchTripData(requestId: requestId)
            }
        timer?.store(in: &cancellables)
    }
    
    private func fetchTripData(requestId: String) {
        Task { @MainActor in
            do {
                generatedTrip = try await tripUseCase.requestResult(requestId: requestId)
                loading = false
                showTrip = true
                timer?.cancel()
                timer = nil
            } catch {
                print("Fetch trip error: \(error.localizedDescription)")
            }
        }
    }
}
