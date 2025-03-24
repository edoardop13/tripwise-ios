//
//  NetworkError.swift
//  TripWise
//
//  Created by Edoardo Pavan on 06/01/25.
//

struct NetworkErrorDataModel: Error, Decodable, Equatable {
    let detail: String?

    enum CodingKeys: String, CodingKey {
        case detail
    }
}
