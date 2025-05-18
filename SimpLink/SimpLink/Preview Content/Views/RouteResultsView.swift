//
//  RouteResultsView.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 15/05/25.
//

import SwiftUI

struct RouteResultsView: View {
    @EnvironmentObject var vm: MapViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Button("Close") {
                    dismiss()
                }
                Spacer()
                Text("Available Routes")
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            if vm.suggestions.isEmpty {
                Text("No routes available")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(vm.suggestions) { suggestion in
                            RouteCard(suggestion: suggestion)
                                .onTapGesture {
                                    vm.selectedSuggestion = suggestion
                                    vm.showRouteDetails = true
                                }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
