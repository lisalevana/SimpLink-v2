//
//  SuggestionsListView.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 15/05/25.
//

import SwiftUI

struct SuggestionsListView: View {
    @EnvironmentObject var vm: MapViewModel
    @FocusState.Binding var focusedField: SearchFieldType? // Match the top-level enum
    
    var body: some View {
        List {
            if focusedField == .from {
                ForEach(vm.fromSuggestions) { stop in
                    Button {
                        vm.selectedFrom = stop
                        vm.searchFrom = stop.name
                        focusedField = nil
                    } label: {
                        HStack {
                            if stop.isBusStop {
                                Image(systemName: "bus.fill")
                                    .foregroundColor(.blue)
                            }
                            Text(stop.name)
                        }
                    }
                }
            }
            
            if focusedField == .to {
                ForEach(vm.toSuggestions) { stop in
                    Button {
                        vm.selectedTo = stop
                        vm.searchTo = stop.name
                        focusedField = nil
                    } label: {
                        HStack {
                            if stop.isBusStop {
                                Image(systemName: "bus.fill")
                                    .foregroundColor(.blue)
                            }
                            Text(stop.name)
                        }
                    }                }
            }
        }
        .listStyle(.plain)
        .frame(maxHeight: 300)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 3)
    }
}
