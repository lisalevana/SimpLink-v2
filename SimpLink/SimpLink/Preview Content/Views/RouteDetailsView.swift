//
//  RouteDetailsView.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 18/05/25.
//

import SwiftUI

struct RouteDetailsView: View {
    let steps: [RouteStep]
    let summaryTitle: String
    let summarySubtitle: String
    let totalDuration: Int
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Back button
                               Button(action: { dismiss() }) {
                                   HStack {
                                       Image(systemName: "chevron.left")
                                       Text("Back")
                                   }
                                   .foregroundColor(.blue)
                               }
                               .padding(.bottom, 8)
                // Top Route Summary
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "bus.fill")
                                .foregroundColor(.black)
                            Text(summaryTitle)
                                .fontWeight(.semibold)
                        }
                        Text(summarySubtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("\(totalDuration) min")
                        .font(.title3)
                        .fontWeight(.bold)
                }

                Button(action: {
                    // Add action here
                }) {
                    Text("Remind me")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Divider()

                // Route Steps
                ForEach(steps) { step in
                    switch step.kind {
                    case .walk(let to, let duration):
                        walkStep(to: to, duration: duration)
                    case .bus(let routeName, let from, let to, let stops, let duration):
                        busStep(routeName: routeName, from: from, to: to, stops: stops, duration: duration)
                    case .destination(let name):
                        destinationStep(name: name)
                    }
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(16)
        .padding()
    }

    private func walkStep(to: String, duration: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "figure.walk")
                Text("Walk to \(to)")
                    .fontWeight(.semibold)
                Spacer()
                Text("\(duration) min")
            }
            Divider()
        }
    }

    private func busStep(routeName: String, from: String, to: String, stops: [String], duration: Int) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "bus.fill")
                Text("\(routeName)")
                    .fontWeight(.semibold)
                Spacer()
                Text("\(duration) min")
            }
            VStack(alignment: .leading, spacing: 2) {
                ForEach(stops, id: \.self) { stop in
                    Text(stop)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
    }

    private func destinationStep(name: String) -> some View {
        HStack {
            Image(systemName: "mappin.and.ellipse")
            Text(name)
                .fontWeight(.semibold)
        }
    }
}


