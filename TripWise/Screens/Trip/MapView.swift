//
//  MapView.swift
//  TripWise
//
//  Created by Edoardo Pavan on 26/01/25.
//

import SwiftUI
import MapKit

//struct MapView: View {
//    let activities: [ActivityModel]
//    @State private var region: MKCoordinateRegion
//
//    init(activities: [ActivityModel]) {
//        self.activities = activities
//        
//        // Set the initial map region to the first activity
//        if let firstActivity = activities.first {
//            _region = State(initialValue: MKCoordinateRegion(
//                center: CLLocationCoordinate2D(latitude: firstActivity.latitude, longitude: firstActivity.longitude),
//                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//            ))
//        } else {
//            _region = State(initialValue: MKCoordinateRegion(
//                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
//                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
//            ))
//        }
//    }
//
//    var body: some View {
//        Map(coordinateRegion: $region, annotationItems: activities) { activity in
//            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: activity.latitude, longitude: activity.longitude)) {
//                VStack {
//                    Image(systemName: "mappin.circle.fill")
//                        .font(.title)
//                        .foregroundColor(.red)
//                    Text(activity.name)
//                        .font(.caption)
//                        .padding(4)
//                        .background(Color.white.opacity(0.8))
//                        .cornerRadius(8)
//                }
//            }
//        }
//        .overlay(PathView(activities: activities).stroke(Color.blue, lineWidth: 2))
//        .edgesIgnoringSafeArea(.all)
//    }
//}
//
//struct PathView: Shape {
//    let activities: [ActivityModel]
//
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        
//        let points = activities.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
//        guard let firstPoint = points.first else { return path }
//        
//        path.move(to: CGPoint(x: firstPoint.longitude, y: firstPoint.latitude))
//        
//        for point in points.dropFirst() {
//            path.addLine(to: CGPoint(x: point.longitude, y: point.latitude))
//        }
//        
//        return path
//    }
//}


// CORRETTO

//struct MapView: View {
//    let activities: [DayEvent]
//    @State private var region: MKCoordinateRegion
//
//    init(activities: [DayEvent]) {
//        self.activities = activities
//
//        // Initialize the region to the first activity's location
//        if let firstActivity = activities.first {
//            _region = State(initialValue: MKCoordinateRegion(
//                center: CLLocationCoordinate2D(latitude: firstActivity.latitude, longitude: firstActivity.longitude),
//                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
//            ))
//        } else {
//            _region = State(initialValue: MKCoordinateRegion(
//                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
//                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
//            ))
//        }
//    }
//
//    var body: some View {
//        Map {
//            // Add annotations for each activity
//            ForEach(activities, id: \.self) { activity in
//                Annotation(activity.name, coordinate: CLLocationCoordinate2D(latitude: activity.latitude, longitude: activity.longitude)) {
//                    VStack {
//                        Image(systemName: "mappin.circle.fill")
//                            .font(.title)
//                            .foregroundColor(.red)
//                        Text(activity.name)
//                            .font(.caption)
//                            .padding(4)
//                            .background(Color.white.opacity(0.8))
//                            .cornerRadius(8)
//                    }
//                }
//            }
//
//            // Add a polyline connecting the activities
//            if activities.count > 1 {
//                let coordinates = activities.map {
//                    CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
//                }
//                MapPolyline(coordinates: coordinates)
//                    .stroke(.green, lineWidth: 3)
//            }
//        }
//        .edgesIgnoringSafeArea(.all)
//    }
//}
//
//#Preview {
//    MapView(
//        activities: [
//            ActivityModel(
//                name: "Colosseum",
//                description: "Description",
//                time: "10:00 AM",
//                cost: 20.0,
//                latitude: 41.8902,
//                longitude: 12.4922
//            ),
//            ActivityModel(
//                name: "Pantheon",
//                description: "Description",
//                time: "12:00 PM",
//                cost: nil,
//                latitude: 41.8986,
//                longitude: 12.4768
//            ),
//            ActivityModel(
//                name: "Trevi Fountain",
//                description: "Description",
//                time: "1:30 PM",
//                cost: 5.0,
//                latitude: 41.9009,
//                longitude: 12.4833
//            )
//        ]
//    )
//}
