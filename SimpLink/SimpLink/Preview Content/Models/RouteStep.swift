//
//  RouteStep.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 18/05/25.
//

import Foundation

struct RouteStep: Identifiable {
    let id = UUID()
    let kind: StepKind

    enum StepKind {
        case walk(to: String, duration: Int)
        case bus(from: String, to: String, stops: [String], duration: Int)
        case destination(name: String)
    }
}


