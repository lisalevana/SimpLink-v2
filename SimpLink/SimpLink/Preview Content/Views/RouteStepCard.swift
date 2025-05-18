//
//  RouteStepCard.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 18/05/25.
//

import SwiftUI

struct RouteStepCard: View {
    let step: RouteStep
    @State private var isExpanded: Bool = false

    var iconName: String {
        switch step.kind {
        case .bus:
            return "bus"
        case .walk:
            return "figure.walk"
        case .destination:
            return "mappin.and.ellipse"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(.blue)
                Text(stepTitle)
                    .font(.headline)
                Spacer()
                Text(stepDuration)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(stepStops, id: \.self) { stop in
                        Text(stop)
                            .font(.subheadline)
                            .padding(.leading, 16)
                            .foregroundColor(.gray)
                    }
                }
                .transition(.opacity)
                .padding(.bottom, 8)
            }
        }
        .padding(.horizontal)
    }

    // Helpers to extract info from StepKind
    var stepTitle: String {
        switch step.kind {
        case .bus(let routeName, let from, let to, _, _):
            return "\(routeName)"
        case .walk(let to, _):
            return "Walk to \(to)"
        case .destination(let name):
            return name
        }
    }

    var stepDuration: String {
        switch step.kind {
        case .bus(_, _, _, _, let duration):
            return "\(duration) min"
        case .walk(_, let duration):
            return "\(duration) min"
        case .destination:
            return ""
        }
    }

    var stepStops: [String] {
        switch step.kind {
        case .bus(_, _, _, let stops, _):
            return stops
        default:
            return []
        }
    }
}
