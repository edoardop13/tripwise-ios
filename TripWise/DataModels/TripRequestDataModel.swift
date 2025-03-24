//
//  TripRequestDataModel.swift
//  TripWise
//
//  Created by Edoardo Pavan on 06/01/25.
//

struct TripRequestDataModel: Encodable {
    let city: String
    let month: String
    let days: Int
    let people: Int
    let withKids: Bool
    
    enum CodingKeys: CodingKey {
        case city
        case month
        case days
        case people
        case withKids
    }
    
    static func from(_ model: TripRequestModel) -> Self {
        .init(
            city: model.city,
            month: model.month,
            days: model.days,
            people: model.people,
            withKids: model.withKids
        )
    }
}
