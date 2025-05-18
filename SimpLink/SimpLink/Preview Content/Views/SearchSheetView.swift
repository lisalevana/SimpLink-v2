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
    var onFocusChange: (SearchFieldType?) -> Void // Callback for focus changes

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 16) {
                searchFields
                if vm.selectedFrom != nil && vm.selectedTo != nil {
                    RouteConfirmationView()
                }
            }
            .padding()
        }
        .onChange(of: focusedField) { newValue in
            onFocusChange(newValue) // Notify parent when focus changes
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

            swapButton
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
