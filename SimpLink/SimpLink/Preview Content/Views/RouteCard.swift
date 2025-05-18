//
//  RouteCard.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 15/05/25.
//

import SwiftUI


struct RouteCard: View {
    let suggestion: RouteSuggestion
    var isFastest: Bool = false

    var departureFrom: String {
        // If the first route is a walking segment, use its destination (to.name)
        if let firstRoute = suggestion.routes.first, firstRoute.name.starts(with: "Walk"), firstRoute.stops.count > 1 {
            return firstRoute.stops[1].name
        }
        // Otherwise, use the first stop as before
        return suggestion.routes.first?.stops.first?.name ?? "-"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isFastest {
                Text("fastest")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.blue))
            }
            HStack {
                Image(systemName: "bus.fill")
                Text(suggestion.transitCount == 0 ? "Direct" : "\(suggestion.transitCount) transit")
                Spacer()
                Text("\(suggestion.totalDuration) min")
                    .font(.headline)
            }
            Text("departs at \(suggestion.departureTime) from \(departureFrom)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.5)))
    }
}
