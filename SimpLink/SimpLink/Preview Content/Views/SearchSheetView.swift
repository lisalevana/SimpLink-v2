//
//  SearchSheetView.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 15/05/25.
//

import SwiftUI
import CoreLocation

enum SearchFieldType {
    case from
    case to
}


struct SearchSheetView: View {
    @EnvironmentObject var vm: MapViewModel
        @FocusState private var focusedField: SearchFieldType?
        var onFocusChange: (SearchFieldType?) -> Void
    @State private var selectedSuggestion: RouteSuggestion? = nil
    
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 16) {
                searchFields
                routeResultsSection
            }
            .padding(.horizontal)
            .onChange(of: vm.selectedFrom) { _ in
                if vm.selectedFrom != nil && vm.selectedTo != nil {
                    vm.calculateRoutes()
                } else {
                    vm.suggestions = []
                }
            }
            .onChange(of: vm.selectedTo) { _ in
                if vm.selectedFrom != nil && vm.selectedTo != nil {
                    vm.calculateRoutes()
                } else {
                    vm.suggestions = []
                }
            }
            .padding()
        }
        .onChange(of: focusedField) { newValue in
            onFocusChange(newValue)
        }
        .sheet(item: $selectedSuggestion) { suggestion in
            let (steps, title, subtitle, duration) = routeSteps(from: suggestion)
            RouteDetailsView(steps: steps, summaryTitle: title, summarySubtitle: subtitle, totalDuration: duration)
        }
    }

    private var routeResultsSection: some View {
        if vm.selectedFrom != nil && vm.selectedTo != nil {
            if vm.suggestions.isEmpty {
                AnyView(
                    Text("No routes available")
                        .foregroundColor(.gray)
                        .padding()
                )
            } else {
                AnyView(
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(
                                vm.suggestions
                                    .sorted {
                                        let (_, _, _, lhsDuration) = routeSteps(from: $0)
                                        let (_, _, _, rhsDuration) = routeSteps(from: $1)
                                        return lhsDuration < rhsDuration
                                    }
                                    .prefix(10)
                                    .enumerated()
                            ), id: \.element.id) { idx, suggestion in
                                let (steps, _, _, totalDurationSteps) = routeSteps(from: suggestion)
                                RouteCard(
                                    suggestion: suggestion,
                                    isFastest: idx == 0, // Now idx==0 is the fastest
                                    totalDuration: totalDurationSteps
                                )
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    selectedSuggestion = suggestion
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                )
            }
        } else {
            AnyView(EmptyView())
        }
    }
    private var searchFields: some View {
        ZStack(alignment: .trailing) {
            VStack(spacing: 8) {
                searchField(
                    icon: "gearshape",
                    text: $vm.searchFrom,
                    placeholder: "Current location",
                    fieldType: .from
                )
                searchField(
                    icon: "mappin.and.ellipse",
                    text: $vm.searchTo,
                    placeholder: "Where to go",
                    fieldType: .to
                )
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)

            // Show swap button only if both locations are selected
            if vm.selectedFrom != nil && vm.selectedTo != nil {
                swapButton
            }
        }
        .padding(.top)
    }
    
    private func searchField(icon: String, text: Binding<String>, placeholder: String, fieldType: SearchFieldType) -> some View {
        ZStack(alignment: .topLeading) {
            IconTextField(
                icon: icon,
                text: text,
                placeholder: placeholder,
                isActive: focusedField == fieldType
            )
            .focused($focusedField, equals: fieldType)
            .onChange(of: text.wrappedValue) { newValue in
                vm.searchSuggestions(for: newValue, isFrom: fieldType == .from)
                // Clear selected value if text is empty
                if newValue.isEmpty {
                    if fieldType == .from {
                        vm.selectedFrom = nil
                    } else {
                        vm.selectedTo = nil
                    }
                }
            }
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            if focusedField == fieldType {
                                vm.suggestionWidth = geo.size.width
                                vm.suggestionOffset = geo.frame(in: .global).maxY
                            }
                        }
                        .onChange(of: focusedField) { _ in
                            if focusedField == fieldType {
                                vm.suggestionWidth = geo.size.width
                                vm.suggestionOffset = geo.frame(in: .global).maxY
                            }
                        }
                }
            )

            if focusedField == fieldType && !text.wrappedValue.isEmpty {
                SuggestionsListView(focusedField: $focusedField)
                    .frame(width: vm.suggestionWidth)
                    .offset(y: 50)
            }
        }
    }

    private var swapButton: some View {
        VStack {
            Button(action: {
                vm.swapLocations()
            }) {
                Image(systemName: "arrow.up.arrow.down.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
        }
        .padding(.trailing, 10)
    }
    
    
    private func routeSteps(from suggestion: RouteSuggestion) -> ([RouteStep], String, String, Int) {
        var steps: [RouteStep] = []
        let routes = suggestion.routes

        let busRoutes = routes.filter { !$0.name.starts(with: "Walk") }
        let summaryTitle = busRoutes.map { $0.name }.joined(separator: " - ")
        let summarySubtitle = "\(routes.first?.stops.first?.name ?? "-") - \(routes.last?.stops.last?.name ?? "-")"
        var totalDurationSteps = 0 // <-- Add this line

        for route in routes {
            if route.name.starts(with: "Walk"), route.stops.count == 2 {
                let distance = route.stops[0].location.distance(to: route.stops[1].location)
                let duration = max(1, Int(distance / 83.33)) // walking speed
                steps.append(RouteStep(kind: .walk(to: route.stops[1].name, duration: duration)))
                totalDurationSteps += duration
            } else if route.stops.count >= 2 {
                let from = route.stops.first!
                let to = route.stops.last!
                let neededStops = route.stops.map { $0.name }
                let duration = max(1, (route.stops.count - 1) * 2) // bus duration
                steps.append(RouteStep(kind: .bus(from: from.name, to: to.name, stops: neededStops, duration: duration)))
                totalDurationSteps += duration
            }
        }
        if let last = routes.last?.stops.last {
            steps.append(RouteStep(kind: .destination(name: last.name)))
        }
        let totalDuration = totalDurationSteps
        return (steps, summaryTitle, summarySubtitle, totalDuration)
    }
}
struct IconTextField: View {
    let icon: String
    @Binding var text: String
    let placeholder: String
    let isActive: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            TextField(placeholder, text: $text)
                .padding(.vertical, 10)
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isActive ? Color.blue : Color.clear, lineWidth: 1)
        )
    }
}

#Preview {
    ContentView()
}
