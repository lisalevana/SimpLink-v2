//
//  ContentView.swift
//  SimpLink
//
//  Created by Elisabeth Levana on 09/05/25.
//

import SwiftUI
import MapKit
import CoreLocation


struct ContentView: View {
    @StateObject private var vm = MapViewModel()
    @State private var showSearchSheet = true
    @State private var sheetDetent: PresentationDetent = .fraction(0.5)

    var body: some View {
        ZStack {
            Map(coordinateRegion: $vm.region, annotationItems: vm.bsdBusStops) { stop in
                MapAnnotation(coordinate: stop.location) {
                    Image(systemName: "bus.fill")
                        .foregroundColor(stop.isBusStop ? .blue : .red)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $showSearchSheet) {
            VStack(alignment: .leading, spacing: 0) {
                SearchSheetView { focusedField in
                    sheetDetent = focusedField != nil ? .fraction(0.8) : .fraction(0.5)
                }
                .environmentObject(vm)
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .padding()
            .background(Color.green)
            .presentationDetents([.fraction(0.8), .fraction(0.5)], selection: $sheetDetent)
            .interactiveDismissDisabled()
            .presentationDragIndicator(.visible)
        }
    }
}
#Preview {
    ContentView()
}


#Preview {
    ContentView()
}
