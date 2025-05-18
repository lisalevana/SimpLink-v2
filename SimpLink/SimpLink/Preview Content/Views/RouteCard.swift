//
//  RouteCard.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 15/05/25.
//

import SwiftUI

struct RouteCard: View {
    let suggestion: RouteSuggestion
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(suggestion.totalDuration) min")
                    .font(.title)
                Text(suggestion.transitCount == 0 ? "Direct" : "\(suggestion.transitCount) transit")
                    .padding(5)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(4)
                Spacer()
                Text(suggestion.departureTime)
            }
            
            ForEach(suggestion.routes) { route in
                HStack {
                    Circle()
                        .fill(route.color)
                        .frame(width: 8, height: 8)
                    Text(route.name)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
