//
//  RouteSuggestion.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 15/05/25.
//

import SwiftUI

struct RouteSuggestion: Identifiable, Hashable {
    let id = UUID()
    let routes: [BusRoute]
    let totalDuration: Int
    let transitCount: Int
    let departureTime: String
    
    static func == (lhs: RouteSuggestion, rhs: RouteSuggestion) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
