//
//  TripRequestResponseDataModel.swift
//  TripWise
//
//  Created by Edoardo Pavan on 22/03/25.
//

import Foundation

struct TripRequestResponseDataModel: Decodable {
    let requestId: String
    
    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
    }
    
    func toModel() -> TripRequestResponseModel {
        .init(requestId: requestId)
    }
}
