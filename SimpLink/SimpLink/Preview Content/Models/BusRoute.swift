//
//  BusRoute.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 15/05/25.
//

import SwiftUI

struct BusRoute: Identifiable, Hashable {
    let id: String
    let name: String
    let stops: [BusStop]
    let color: Color
    let departureTimes: [String]
    
    static func == (lhs: BusRoute, rhs: BusRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func routeColor(for id: String) -> Color {
        switch id {
        case "R01": return Color(UIColor.route1)
        case "R02": return Color(UIColor.route2)
        case "R03": return Color(UIColor.route3)
        case "R04": return Color(UIColor.route4)
        case "R05": return Color(UIColor.route5)
        case "R06": return Color(UIColor.route6)
        default: return Color.blue
        }
    }
}
