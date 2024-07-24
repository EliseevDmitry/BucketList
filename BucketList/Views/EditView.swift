//
//  EditView.swift
//  BucketList
//
//  Created by Dmitriy Eliseev on 23.07.2024.
//

import SwiftUI
import CoreLocation

struct EditView: View {
    //MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: EditViewModel
    var location: Location
    var onSave: (Location) -> Void
    //MARK: - BODY
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                Section("Nearby…") {
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description )
                                .italic()
                        }
                    case .loading:
                        Text("Loading…")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    var newLocation = viewModel.location
                    newLocation.id = UUID()
                    newLocation.name = viewModel.name
                    newLocation.description = viewModel.description
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces(coordinate: viewModel.location.coordinate)
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void){
        self.location = location
        self.onSave = onSave
        _viewModel = State(initialValue: EditViewModel(location: location))
    }
}

//MARK: - PREVIEW
#Preview {
    //{_ in} - из-за использования замыкания
    EditView(location: Location(name: "", description: "", latitude: 1.0, longitude: 1.0)) {_ in}
}
