//
//  TripEntity.swift
//  TripWise
//
//  Created by Edoardo Pavan on 28/01/25.
//

import Foundation
import RealmSwift

class TripEntity: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var generatedAt: Date?
    @Persisted var tripSummary: TripSummaryEntity?
    @Persisted var days = List<DayPlanEntity>()
    
    // MARK: - Conversion to Model
    func toModel() -> Trip {
        Trip(
            generatedAt: generatedAt,
            tripSummary: tripSummary?.toModel() ?? TripSummary(totalDays: 0, estimatedCostPerPerson: EstimatedCost(activities: 0.0, meals: 0.0, transport: 0.0)),
            days: days.map { $0.toModel() }
        )
    }
    
    // MARK: - Conversion from Model
    static func from(_ model: Trip) -> TripEntity {
        let entity = TripEntity()
        
        // tripSummary
        let summary = TripSummaryEntity.from(model.tripSummary)
        entity.tripSummary = summary
        
        // days
        let daysList = List<DayPlanEntity>()
        model.days.forEach { dayModel in
            daysList.append(DayPlanEntity.from(dayModel))
        }
        entity.days = daysList
        
        return entity
    }
}

class TripSummaryEntity: EmbeddedObject {
    @Persisted var totalDays: Int = 0
    @Persisted var estimatedCostPerPerson: EstimatedCostEntity?
    
    func toModel() -> TripSummary {
        TripSummary(
            totalDays: totalDays,
            estimatedCostPerPerson: estimatedCostPerPerson?.toModel() ?? EstimatedCost(activities: 0.0, meals: 0.0, transport: 0.0)
        )
    }
    
    static func from(_ model: TripSummary) -> TripSummaryEntity {
        let entity = TripSummaryEntity()
        entity.totalDays = model.totalDays
        entity.estimatedCostPerPerson = EstimatedCostEntity.from(model.estimatedCostPerPerson)
        return entity
    }
}

class EstimatedCostEntity: EmbeddedObject {
    @Persisted var activities: Double = 0.0
    @Persisted var meals: Double = 0.0
    @Persisted var transport: Double = 0.0
    
    func toModel() -> EstimatedCost {
        EstimatedCost(
            activities: activities,
            meals: meals,
            transport: transport
        )
    }
    
    static func from(_ model: EstimatedCost) -> EstimatedCostEntity {
        let entity = EstimatedCostEntity()
        entity.activities = model.activities
        entity.meals = model.meals
        entity.transport = model.transport
        return entity
    }
}

class DayPlanEntity: EmbeddedObject {
    @Persisted var dayNumber: Int = 0
    @Persisted var theme: String = ""
    
    @Persisted var activities = List<ActivityEntity>()
    @Persisted var meals = List<MealEntity>()
    
    func toModel() -> DayPlan {
        DayPlan(
            dayNumber: dayNumber,
            theme: theme,
            activities: activities.map { $0.toModel() },
            meals: meals.map { $0.toModel() }
        )
    }
    
    static func from(_ model: DayPlan) -> DayPlanEntity {
        let entity = DayPlanEntity()
        entity.dayNumber = model.dayNumber
        entity.theme = model.theme
        
        // Attività
        let activitiesList = List<ActivityEntity>()
        model.activities.forEach { activityModel in
            activitiesList.append(ActivityEntity.from(activityModel))
        }
        entity.activities = activitiesList
        
        // Pasti
        let mealsList = List<MealEntity>()
        model.meals.forEach { mealModel in
            mealsList.append(MealEntity.from(mealModel))
        }
        entity.meals = mealsList
        
        return entity
    }
}

class ActivityEntity: EmbeddedObject {
    @Persisted var type: String = ""
    @Persisted var name: String = ""
    @Persisted var desc: String = ""
    @Persisted var costEuroPerPerson: Double = 0
    @Persisted var timeWindow: TimeWindowEntity?
    @Persisted var coordinates: CoordinatesEntity?
    @Persisted var proTip: String = ""
    @Persisted var needBooking: Bool = false
    
    // nextTransport facoltativo
    @Persisted var nextTransport: NextTransportEntity?
    
    // MARK: - toModel
    func toModel() -> Activity {
        Activity(
            type: type,
            name: name,
            description: desc,
            costEuroPerPerson: costEuroPerPerson,
            timeWindow: timeWindow?.toModel() ?? TimeWindow(recommendedStart: "", durationMin: 0, crowdForecast: ""),
            coordinates: coordinates?.toModel() ?? Coordinates(lat: 0, lng: 0),
            proTip: proTip,
            needBooking: needBooking,
            nextTransport: nextTransport?.toModel()
        )
    }
    
    // MARK: - from
    static func from(_ model: Activity) -> ActivityEntity {
        let entity = ActivityEntity()
        entity.type = model.type
        entity.name = model.name
        entity.desc = model.description
        entity.costEuroPerPerson = model.costEuroPerPerson
        
        entity.timeWindow = TimeWindowEntity.from(model.timeWindow)
        if let coordinates = model.coordinates {
            entity.coordinates = CoordinatesEntity.from(coordinates)
        }
        entity.proTip = model.proTip
        entity.needBooking = model.needBooking
        
        if let nt = model.nextTransport {
            entity.nextTransport = NextTransportEntity.from(nt)
        }
        
        return entity
    }
}

class MealEntity: EmbeddedObject {
    @Persisted var name: String = ""
    @Persisted var cuisine: String = ""
    @Persisted var costEuroPerPerson: Double = 0
    @Persisted var timeWindow: TimeWindowEntity?
    @Persisted var address: String = ""
    @Persisted var proTip: String = ""
    
    // Lista di stringhe per le diete
    @Persisted var dietary = List<String>()
    
    // MARK: - toModel
    func toModel() -> Meal {
        Meal(
            name: name,
            cuisine: cuisine,
            costEuroPerPerson: costEuroPerPerson,
            timeWindow: timeWindow?.toModel() ?? TimeWindow(recommendedStart: "", durationMin: 0, crowdForecast: ""),
            address: address,
            dietary: dietary.map { $0 },
            proTip: proTip
        )
    }
    
    // MARK: - from
    static func from(_ model: Meal) -> MealEntity {
        let entity = MealEntity()
        entity.name = model.name
        entity.cuisine = model.cuisine
        entity.costEuroPerPerson = model.costEuroPerPerson
        entity.timeWindow = TimeWindowEntity.from(model.timeWindow)
        entity.address = model.address
        entity.proTip = model.proTip
        
        let list = List<String>()
        model.dietary.forEach { list.append($0) }
        entity.dietary = list
        
        return entity
    }
}

class TimeWindowEntity: EmbeddedObject {
    @Persisted var recommendedStart: String = ""
    @Persisted var durationMin: Int = 0
    @Persisted var crowdForecast: String = ""
    
    func toModel() -> TimeWindow {
        TimeWindow(
            recommendedStart: recommendedStart,
            durationMin: durationMin,
            crowdForecast: crowdForecast
        )
    }
    
    static func from(_ model: TimeWindow) -> TimeWindowEntity {
        let entity = TimeWindowEntity()
        entity.recommendedStart = model.recommendedStart
        entity.durationMin = model.durationMin
        entity.crowdForecast = model.crowdForecast
        return entity
    }
}

class CoordinatesEntity: EmbeddedObject {
    @Persisted var lat: Double = 0
    @Persisted var lng: Double = 0
    
    func toModel() -> Coordinates {
        Coordinates(lat: lat, lng: lng)
    }
    
    static func from(_ model: Coordinates) -> CoordinatesEntity {
        let entity = CoordinatesEntity()
        entity.lat = model.lat
        entity.lng = model.lng
        return entity
    }
}

class NextTransportEntity: EmbeddedObject {
    @Persisted var recommended: RecommendedTransportEntity?
    @Persisted var alternative: AlternativeTransportEntity?
    
    func toModel() -> NextTransport {
        NextTransport(
            recommended: recommended?.toModel() ?? RecommendedTransport(type: "", details: TransportDetails(time: nil, line: nil, stops: nil), cost: ""),
            alternative: alternative?.toModel() ?? AlternativeTransport(type: "",
                                                                        details: TransportDetails(time: nil, line: nil, stops: nil),
                                                                        cost: "",
                                                                        convenienceAnalysis: ConvenienceAnalysis(timeSaved: "", costVSBenefit: "", recommendation_score: ""))
        )
    }
    
    static func from(_ model: NextTransport) -> NextTransportEntity {
        let entity = NextTransportEntity()
        entity.recommended = RecommendedTransportEntity.from(model.recommended)
        entity.alternative = AlternativeTransportEntity.from(model.alternative)
        return entity
    }
}

class TransportDetailsEntity: EmbeddedObject {
    @Persisted var time: String?
    @Persisted var line: String?
    @Persisted var stops: String?
    
    func toModel() -> TransportDetails {
        TransportDetails(time: time, line: line, stops: stops)
    }
    
    static func from(_ model: TransportDetails) -> TransportDetailsEntity {
        let entity = TransportDetailsEntity()
        entity.time = model.time
        entity.line = model.line
        entity.stops = model.stops
        return entity
    }
}

class RecommendedTransportEntity: EmbeddedObject {
    @Persisted var type: String = ""
    @Persisted var details: TransportDetailsEntity?
    @Persisted var cost: String = ""
    
    func toModel() -> RecommendedTransport {
        RecommendedTransport(
            type: type,
            details: details?.toModel() ?? TransportDetails(time: nil, line: nil, stops: nil),
            cost: cost
        )
    }
    
    static func from(_ model: RecommendedTransport) -> RecommendedTransportEntity {
        let entity = RecommendedTransportEntity()
        entity.type = model.type
        entity.details = TransportDetailsEntity.from(model.details)
        entity.cost = model.cost
        return entity
    }
}

class AlternativeTransportEntity: EmbeddedObject {
    @Persisted var type: String = ""
    @Persisted var details: TransportDetailsEntity?
    @Persisted var cost: String = ""
    @Persisted var convenienceAnalysis: ConvenienceAnalysisEntity?
    
    func toModel() -> AlternativeTransport {
        AlternativeTransport(
            type: type,
            details: details?.toModel() ?? TransportDetails(time: nil, line: nil, stops: nil),
            cost: cost,
            convenienceAnalysis: convenienceAnalysis?.toModel() ?? ConvenienceAnalysis(timeSaved: "", costVSBenefit: "", recommendation_score: "")
        )
    }
    
    static func from(_ model: AlternativeTransport) -> AlternativeTransportEntity {
        let entity = AlternativeTransportEntity()
        entity.type = model.type
        entity.details = TransportDetailsEntity.from(model.details)
        entity.cost = model.cost
        entity.convenienceAnalysis = ConvenienceAnalysisEntity.from(model.convenienceAnalysis)
        return entity
    }
}

class ConvenienceAnalysisEntity: EmbeddedObject {
    @Persisted var timeSaved: String = ""
    @Persisted var costVSBenefit: String = ""
    @Persisted var recommendationScore: String = ""
    
    func toModel() -> ConvenienceAnalysis {
        ConvenienceAnalysis(
            timeSaved: timeSaved,
            costVSBenefit: costVSBenefit,
            recommendation_score: recommendationScore
        )
    }
    
    static func from(_ model: ConvenienceAnalysis) -> ConvenienceAnalysisEntity {
        let entity = ConvenienceAnalysisEntity()
        entity.timeSaved = model.timeSaved
        entity.costVSBenefit = model.costVSBenefit
        entity.recommendationScore = model.recommendation_score
        return entity
    }
}
