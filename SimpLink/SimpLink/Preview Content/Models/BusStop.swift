//
//  BusStop.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 15/05/25.
//

import CoreLocation

extension CLLocationCoordinate2D: Hashable, Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}


struct BusStop: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let location: CLLocationCoordinate2D
    let isBusStop: Bool
    
    static func == (lhs: BusStop, rhs: BusStop) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.location == rhs.location &&
               lhs.isBusStop == rhs.isBusStop
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(location)
        hasher.combine(isBusStop)
    }
}
