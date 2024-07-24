//
//  IntegratingMapKit.swift
//  BucketList
//
//  Created by Dmitriy Eliseev on 21.07.2024.
//

import SwiftUI
import MapKit
//Любое положение на крте должно быть подписано под протокол Identifiable

struct IntegratingMapKit: View {
    //MARK: - PROPERTIES
    //London position
    @State private var position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
    @State private var viewModel = ViewModel()
    //MARK: - BODY
    var body: some View {
        VStack {
            if viewModel.isUnloced {
                ZStack{
                    MapReader{ proxy in
                        Map(position: $position){
                            ForEach(viewModel.locations){location in
                                //стандартный маркер на карте
                                //Marker(location.name, coordinate: location.coordinate)
                                
                                //Кастомный маркер на карте
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Text(location.name)
                                        .font(.headline)
                                        .padding()
                                        .background(.blue.gradient)
                                        .foregroundStyle(.white)
                                        .clipShape(.capsule)
                                        .onLongPressGesture {
                                            viewModel.selectedPlace = location
                                        }
                                }
                                .annotationTitles(.hidden)
                            }
                        }
                        .mapStyle(viewModel.isMapStyle ? .hybrid : .standard)
                        
                        //определение координаты по нажатию
                        .onTapGesture { position in
                            //.local - текущий фрагмент карты на экране, .global вся карта
                            if let coordinate = proxy.convert(position, from: .local){
                                viewModel.addLocation(at: coordinate )
                            }
                        }
                    }
                    //модификатор изменения позиции камеры
                    //срабатывает только после перетаскивания (после остановки)
                    .onMapCameraChange {context in
                        print(context.region)
                    }
                    
                    //модификатор изменения позиции камеры
                    //срабатывает в режиме реального времени
                    //.onMapCameraChange(frequency: .continuous) {context in
                    //print(context.region)
                    //}
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.updateLocation(loation: $0)
                        }
                    }
                }
                HStack(spacing: 50){
                    Spacer()
                    Button("Paris"){
                        position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
                    }
                    Button("Tokyo"){
                        position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.6897, longitude: 139.6922), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
                    }
                    Toggle("MapStyle", isOn: $viewModel.isMapStyle)
                    Spacer()
                }
            } else {
                Button("UnLocked", action: viewModel.authenticate)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule )
                    .alert("Error.", isPresented: $viewModel.isError) {
                        Text(viewModel.errorAuthentication ?? "Error authenticate.")
                        Button("Ok"){
                            viewModel.isError = false
                        }
                    }
            }
        }
    }
}

//MARK: - PREVIEW
#Preview {
    IntegratingMapKit()
}
