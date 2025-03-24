//
//  HistoryNavigationPages.swift
//  TripWise
//
//  Created by Edoardo Pavan on 26/01/25.
//

enum HistoryNavigationPages: Hashable {
    case map([DayEvent])
    case tripDetail(Trip)
}
