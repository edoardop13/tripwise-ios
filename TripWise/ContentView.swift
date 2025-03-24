//
//  ContentView.swift
//  TripWise
//
//  Created by Edoardo Pavan on 19/11/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    
    private let startingPoint = CLLocationCoordinate2D(
        latitude: 40.83657722488077,
        longitude: 14.306896671048852
    )
    
    private let destinationCoordinates = CLLocationCoordinate2D(
        latitude: 40.849761,
        longitude: 15.263364
    )
    
    var body: some View {
        Map(selection: $selectedResult) {
            // Adding the marker for the starting point
            Marker("Start", coordinate: self.startingPoint)
            
            // Show the route if it is available
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        .onChange(of: selectedResult){
            getDirections()
        }
        .onAppear {
            self.selectedResult = MKMapItem(placemark: MKPlacemark(coordinate: self.destinationCoordinates))
        }
    }
        
    func getDirections() {
        self.route = nil
        
        // Check if there is a selected result
        guard let selectedResult else { return }
        
        // Create and configure the request
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.startingPoint))
        request.destination = self.selectedResult
        
        // Get the directions based on the request
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
}

#Preview {
    ContentView()
}
