//
//  RouteStep.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 18/05/25.
//

import Foundation

struct RouteStep: Identifiable {
    let id = UUID()
    let kind: RouteStepKind

    enum RouteStepKind {
        case walk(to: String, duration: Int)
        case bus(routeName: String, from: String, to: String, stops: [String], duration: Int)
        case destination(name: String)
    }
}
