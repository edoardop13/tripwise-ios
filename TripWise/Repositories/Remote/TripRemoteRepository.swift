//
//  TripRemoteRepository.swift
//  TripWise
//
//  Created by Edoardo Pavan on 06/01/25.
//

import CommonNetworking
import Dependencies
import Foundation

protocol TripRemoteRepository {
    func submit(_ model: TripRequestDataModel) async throws -> TripRequestResponseModel
    func requestResult(requestId: String) async throws -> Trip
}

struct TripRemoteLiveRepository: TripRemoteRepository {
    @Dependency(\.environment) private var environment
    private let client: APIClient<NetworkErrorDataModel>
    
    init(
        client: APIClient<NetworkErrorDataModel> = APIClient()
    ) {
        self.client = client
    }
    
    func submit(_ model: TripRequestDataModel) async throws -> TripRequestResponseModel {
        let response: TripRequestResponseDataModel = try await client.run(
            client.buildRequest(
                APIRequestSettings(
                    url: environment.baseUrl,
                    urlPathComponent: "/search",
                    httpBody: JSONEncoder().encode(model),
                    httpMethod: .post,
                    httpHeaderFields: [
                        Headers.contentType.rawValue: "application/json"
                    ]
                )
            )
        )
        return response.toModel()
    }
    
    func requestResult(requestId: String) async throws -> Trip {
        var urlQueryParameters: [String: String] = [:]
        
        urlQueryParameters["request_id"] = requestId
        
        let response: Trip = try await client.run(
            client.buildRequest(
                APIRequestSettings(
                    url: environment.baseUrl,
                    urlPathComponent: "/result",
                    urlQueryParameters: urlQueryParameters,
                    httpMethod: .get,
                    httpHeaderFields: [
                        Headers.contentType.rawValue: "application/json"
                    ]
                )
            )
        )
        return response
    }
    
}
