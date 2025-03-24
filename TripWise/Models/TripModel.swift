//
//  TripModel.swift
//  TripWise
//
//  Created by Edoardo Pavan on 06/01/25.
//

import Foundation

struct TransportDetails: Codable, Hashable {
    let time: String?
    let line: String?
    let stops: String?
    
    enum CodingKeys: String, CodingKey {
        case time
        case line
        case stops
    }
}
struct RecommendedTransport: Codable, Hashable {
    let type: String
    let details: TransportDetails
    let cost: String
    
    enum CodingKeys: CodingKey {
        case type
        case details
        case cost
    }
}
struct ConvenienceAnalysis: Codable, Hashable {
    let timeSaved: String
    let costVSBenefit: String
    let recommendation_score: String
    
    enum CodingKeys: String, CodingKey {
        case timeSaved = "time_saved"
        case costVSBenefit = "cost_vs_benefit"
        case recommendation_score = "recommendation_score"
    }
}
struct AlternativeTransport: Codable, Hashable {
    let type: String
    let details: TransportDetails
    let cost: String
    let convenienceAnalysis: ConvenienceAnalysis
    
    enum CodingKeys: String, CodingKey {
        case type
        case details
        case cost
        case convenienceAnalysis = "convenience_analysis"
    }
}
struct NextTransport: Codable, Hashable {
    let recommended: RecommendedTransport
    let alternative: AlternativeTransport
    
    enum CodingKeys: String, CodingKey {
        case recommended
        case alternative
    }
}
struct TimeWindow: Codable, Hashable {
    let recommendedStart: String
    let durationMin: Int
    let crowdForecast: String
    
    enum CodingKeys: String, CodingKey {
        case recommendedStart = "recommended_start"
        case durationMin = "duration_min"
        case crowdForecast = "crowd_forecast"
    }
}
struct Coordinates: Codable, Hashable {
    let lat: Double
    let lng: Double
}
struct Activity: Codable, Hashable {
    let type: String
    let name: String
    let description: String
    let costEuroPerPerson: Double
    let timeWindow: TimeWindow
    let coordinates: Coordinates?
    let proTip: String
    let needBooking: Bool
    let nextTransport: NextTransport?
    
    enum CodingKeys: String, CodingKey {
        case type
        case name
        case description
        case costEuroPerPerson = "cost_pp"
        case timeWindow = "time_window"
        case coordinates
        case proTip = "pro_tip"
        case needBooking = "need_booking"
        case nextTransport = "next_transport"
    }
}
struct Meal: Codable, Hashable {
    let name: String
    let cuisine: String
    let costEuroPerPerson: Double
    let timeWindow: TimeWindow
    let address: String
    let dietary: [String]
    let proTip: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case cuisine
        case costEuroPerPerson = "cost_pp"
        case timeWindow = "time_window"
        case address
        case dietary
        case proTip = "pro_tip"
    }
}
struct DayPlan: Codable, Hashable {
    let dayNumber: Int
    let theme: String

    let activities: [Activity]
    let meals: [Meal]
    
    enum CodingKeys: String, CodingKey {
        case dayNumber = "day_number"
        case theme
        case activities
        case meals
    }
    
    /// Calcola e restituisce gli eventi di un giorno (attività e pasti) in un'unica lista
    var dayEvents: [DayEvent] {
        let activityEvents = activities.map { DayEvent.activity($0) }
        let mealEvents = meals.map { DayEvent.meal($0) }
        let merged = activityEvents + mealEvents
        return merged.sorted { $0.startTime < $1.startTime }
    }
}

/// Enum che rappresenta un "evento" della giornata, che può essere:
/// - un'Attività (`activity`)
/// - un Pasto (`meal`)
enum DayEvent: Hashable {
    case activity(Activity)
    case meal(Meal)
    
    var startTime: String {
        switch self {
        case .activity(let a):
            a.timeWindow.recommendedStart
        case .meal(let m):
            m.timeWindow.recommendedStart
        }
    }
    
    var duration: Int {
        switch self {
        case .activity(let a):
            a.timeWindow.durationMin
        case .meal(let m):
            m.timeWindow.durationMin
        }
    }
    
    var name: String {
        switch self {
        case .activity(let a):
            a.name
        case .meal(let m):
            m.name
        }
    }
    
    var description: String {
        switch self {
        case .activity(let a):
            a.description
        case .meal(let m):
            m.cuisine
        }
    }
    
    /// Costo per persona
    var costPerPerson: Double {
        switch self {
        case .activity(let a):
            a.costEuroPerPerson
        case .meal(let m):
            m.costEuroPerPerson
        }
    }
    
    var crowdForecast: String {
        switch self {
        case .activity(let a):
            a.timeWindow.crowdForecast
        case .meal(let m):
            m.timeWindow.crowdForecast
        }
    }
    
    var nextTransport: NextTransport? {
        switch self {
        case .activity(let a):
            a.nextTransport
        case .meal:
            nil
        }
    }
}
struct EstimatedCost: Codable, Hashable {
    let activities: Double
    let meals: Double
    let transport: Double
}
struct TripSummary: Codable, Hashable {
    let totalDays: Int
    let estimatedCostPerPerson: EstimatedCost
    
    enum CodingKeys: String, CodingKey {
        case totalDays = "total_days"
        case estimatedCostPerPerson = "estimated_cost_per_person"
    }
}
struct Trip: Codable, Hashable {
    let generatedAt: Date?
    let tripSummary: TripSummary
    let days: [DayPlan]
    
    enum CodingKeys: String, CodingKey {
        case tripSummary = "trip_summary"
        case days
        case generatedAt
    }
}
