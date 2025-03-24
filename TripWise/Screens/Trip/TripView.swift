//
//  PlannerView.swift
//  TripWise
//
//  Created by Edoardo Pavan on 25/01/25.
//

import SwiftUI

struct TripView: View {
    let trip: Trip
//    var openMap: ([DayEvent]) -> ()
    @State private var expandedDays: Set<DayPlan> = []

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                tripSummary
                ForEach(trip.days, id: \.self) { day in
                    VStack(spacing: 8) {
                        Button(action: {
                            withAnimation {
                                if expandedDays.contains(day) {
                                    expandedDays.remove(day)
                                } else {
                                    expandedDays.insert(day)
                                }
                            }
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(day.theme)
                                        .font(.headline)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    Text("Day: \(day.dayNumber)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                                Image(systemName: expandedDays.contains(day) ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 10)
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

                        if expandedDays.contains(day) {
                            ForEach(day.dayEvents, id: \.self) { activity in
                                switch activity {
                                case .activity(let activity):
                                    ActivityView(activity: activity)
                                case .meal(let meal):
                                    MealView(meal: meal)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    private var tripSummary: some View {
        // Summary Header
        VStack(alignment: .leading, spacing: 8) {
            Text("Generated Trip")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack(spacing: 20) {
                TripCostItem(title: "Activities", amount: trip.tripSummary.estimatedCostPerPerson.activities)
                TripCostItem(title: "Meals", amount: trip.tripSummary.estimatedCostPerPerson.meals)
                TripCostItem(title: "Transport", amount: trip.tripSummary.estimatedCostPerPerson.transport)
                Spacer()
                Text("\(trip.tripSummary.totalDays) Days")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, 5)
        .padding(.bottom, 15)
    }
    
    private struct ActivityView: View {
        var activity: Activity
        
        var body: some View {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(activity.type.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 4)
                        .background(Color(uiColor:.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .padding(.top, 5)
                    Text(activity.name)
                        .font(.headline)
                    Text(activity.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    HStack {
                        Label("Start at: \(activity.timeWindow.recommendedStart)", systemImage: "clock")
                        Spacer()
                        Text("Duration: \(activity.timeWindow.durationMin)min")
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                    Label("€\(activity.costEuroPerPerson, specifier: "%.2f")", systemImage: "eurosign.circle")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Label(activity.needBooking ? "Booking required" : "Booking not required", systemImage: "bookmark.circle.fill")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("💡 \(activity.proTip)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    if let transport = activity.nextTransport?.recommended {
                        Text("Recommended transport")
                            .font(.callout)
                        HStack {
                            Text("\(transport.type.capitalized)")
                            Spacer()
                            Label("\(transport.cost)", systemImage: "eurosign.circle")
                            if let line = transport.details.line {
                                Text("Line: \(line)")
                                    .foregroundColor(.gray)
                            }
                            if let stops = transport.details.stops {
                                Text("\(stops)")
                                    .foregroundColor(.gray)
                            }
                            if let time = transport.details.time {
                                Text("Time: \(time)")
                                    .foregroundColor(.gray)
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    }
                    
                    if let transport = activity.nextTransport?.alternative {
                        Text("Alternative transport")
                            .font(.callout)
                        HStack {
                            Text("\(transport.type.capitalized)")
                            Spacer()
                            Label("\(transport.cost)", systemImage: "eurosign.circle")
                            if let line = transport.details.line {
                                Text("Line: \(line)")
                                    .foregroundColor(.gray)
                            }
                            if let stops = transport.details.stops {
                                Text("\(stops)")
                                    .foregroundColor(.gray)
                            }
                            if let time = transport.details.time {
                                Text("Time: \(time)")
                                    .foregroundColor(.gray)
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
    
    private struct MealView: View {
        var meal: Meal
        
        var body: some View {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(meal.name)
                        .font(.headline)
                    Text(meal.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    HStack {
                        Label("Start at: \(meal.timeWindow.recommendedStart)", systemImage: "clock")
                        Spacer()
                        Text("Duration: \(meal.timeWindow.durationMin) min")
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                    Label("€\(meal.costEuroPerPerson, specifier: "%.2f")", systemImage: "eurosign.circle")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("💡 \(meal.proTip)")
                        .font(.footnote)
                        .foregroundColor(.blue)
                    if !meal.dietary.isEmpty {
                        Text("Dietary:")
                        ForEach(meal.dietary, id: \.self) { dietary in
                            Text("- \(dietary)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}

struct TripCostItem: View {
    var title: String
    var amount: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("€\(amount, specifier: "%.2f")")
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    TripView(
        trip: Trip(
            generatedAt: Date(),
            tripSummary: TripSummary(totalDays: 2, estimatedCostPerPerson: EstimatedCost(activities: 20, meals: 20, transport: 20)),
            days: [
                DayPlan(
                    dayNumber: 1,
                    theme: "Day Theme",
                    activities: [
                        Activity(
                            type: "Landmark",
                            name: "Activity Name",
                            description: "Activity Description",
                            costEuroPerPerson: 20,
                            timeWindow: TimeWindow(recommendedStart: "10", durationMin: 20, crowdForecast: "Good"),
                            coordinates: nil,
                            proTip: "Pro Tip",
                            needBooking: true,
                            nextTransport: NextTransport(
                                recommended: RecommendedTransport(type: "Walk", details: TransportDetails(time: "10", line: "1", stops: "2"), cost: "20"),
                                alternative: AlternativeTransport(
                                    type: "Bus",
                                    details: TransportDetails(
                                        time: "10",
                                        line: "2",
                                        stops: "3"
                                    ),
                                    cost: "40",
                                    convenienceAnalysis: ConvenienceAnalysis(timeSaved: "2", costVSBenefit: "Good", recommendation_score: "3/10")
                                )
                            )
                        )
                    ],
                    meals: [
                        Meal(name: "Restaurant Name", cuisine: "cuisine", costEuroPerPerson: 3.0, timeWindow: TimeWindow(recommendedStart: "10", durationMin: 20, crowdForecast: "Good"), address: "Address", dietary: [""], proTip: "Pro tip")
                    ]
                )
            ]
        )
    )
}
