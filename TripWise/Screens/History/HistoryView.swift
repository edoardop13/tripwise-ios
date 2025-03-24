//
//  HistoryView.swift
//  TripWise
//
//  Created by Edoardo Pavan on 26/01/25.
//

import SwiftUI

struct HistoryView: View {
    @Environment(NavigationRouter<HistoryNavigationPages>.self) private var historyRouter
    @State private var viewModel = HistoryViewModel()

    var body: some View {
        @Bindable var historyRouter = self.historyRouter
        @Bindable var viewModel = self.viewModel
        
        NavigationStack(path: $historyRouter.navigationPath) {
            ScrollView {
                LazyVStack(spacing: 16) {
                    title
                    tripList
                }
                .padding()
                .task {
                    await viewModel.loadTrips()
                }
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationDestination(for: HistoryNavigationPages.self) { page in
                switch page {
                case .tripDetail(let trip):
                    TripView(trip: trip)
//                    { activities in
//                        historyRouter.navigate(to: .map(activities))
//                    }
                case .map(let activities):
                    EmptyView()
//                    MapView(activities: activities)
                }
            }
        }
    }
    
    private var title: some View {
        Text("History")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.bottom, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
    }
    
    private var tripList: some View {
        ForEach(viewModel.groupedTrips, id: \.0) { (date, trips) in
            VStack(alignment: .leading, spacing: 8) {
                Text(date)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                ForEach(trips, id: \.self) { trip in
                    Button(action: {
                        historyRouter.navigate(to: .tripDetail(trip))
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                if let generatedAt = trip.generatedAt {
                                    Text("Generated on: \(generatedAt.formatted(date: .abbreviated, time: .shortened))")
                                        .font(.headline)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                }
                                Text("\(trip.tripSummary.totalDays) days trip")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(UIColor.white))
                        )
                        .shadow(
                            color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
