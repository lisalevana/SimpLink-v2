//
//  RouteConfirmationView.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 15/05/25.
//

import SwiftUI

struct RouteConfirmationView: View {
    @EnvironmentObject private var vm: MapViewModel
    @State private var isCalculating = false
    
    var body: some View {
        VStack {
            if let fromStop = vm.selectedFrom, let toStop = vm.selectedTo {
                HStack {
                    VStack(alignment: .leading) {
                        Text("From")
                            .font(.caption)
                        Text(fromStop.name)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("To")
                            .font(.caption)
                        Text(toStop.name)
                            .font(.headline)
                    }
                }
                .padding()
                
                Button("Show Routes") {
                    isCalculating = true
                    vm.calculateRoutes()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isCalculating)
                .padding()
            } else {
                Text("Please select both locations")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .sheet(isPresented: $vm.showRouteResults) {
            isCalculating = false
        } content: {
            RouteResultsView()
                .environmentObject(vm)
        }
    }
}
