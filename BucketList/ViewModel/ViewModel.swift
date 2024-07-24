//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Dmitriy Eliseev on 23.07.2024.
//

import CoreLocation
import Foundation
import MapKit
import LocalAuthentication

extension IntegratingMapKit{
    @Observable
    class ViewModel {
        private(set) var locations: [Location] // есть инициализатор - устанавливающий еачальные значения
        var selectedPlace: Location?
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        var isUnloced = false
        var isMapStyle = false
        var errorAuthentication: String?
        var isError = false
        
        
        init(){
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save(){
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(
                name: "",
                description: "",
                latitude: point.latitude,
                longitude: point.longitude
            )
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(loation: Location) {
            guard let selectedPlace else { return }
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = loation
                save()
            }
        }
        
        func authenticate(){
            let context = LAContext()
            var error: NSError?
            //&error - из Objective-C
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error ){
                let reason = "Please authenticate yourself to unlock you places."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {success, authentificationError in
                    if success {
                        self.isUnloced = true
                    } else {
                        //error
                        self.errorAuthentication = authentificationError?.localizedDescription
                        self.isError = true
                    }
                }
            } else {
                //no biometrics
                self.errorAuthentication = "Error. You device does not support biometrics authentication."
                isError = true
            }
        }
        
        
        
        
    }
}


extension EditView{
    @Observable
    class EditViewModel {
       var location: Location
        
        var loadingState = LoadingState.loading
        var pages = [Page]()
        var name: String
        var description: String
        
        init(location: Location) {
            self.location = location
            self.name = location.name
            self.description = location.description
        }
        
        //@State private var (name/description)Решение состоит в том, чтобы создать новый инициализатор, который принимает местоположение (Location) и использует его для создания структур State с использованием данных местоположения. Здесь используется тот же подход подчеркивания, который мы использовали при создании запроса SwiftData внутри инициализатора, что позволяет нам создавать экземпляр оболочки свойства, а не данные внутри оболочки.
        //Escaping Closures (сбегающие замыкания)
        

        
        
        func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(coordinate.latitude)%7C\(coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            guard let url = URL(string: urlString) else {
                print("Bad URL: \(urlString)")
                return
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                // we got some data back!
                let items = try JSONDecoder().decode(Result.self, from: data)
                // success – convert the array values to our pages array
                pages = items.query.pages.values.sorted() //{ $0.title < $1.title } - не требуется после подписание под протокол Comparable - структуры Page
                loadingState = .loaded
            } catch {
                // if we're still here it means the request failed somehow
                loadingState = .failed
            }
        }
    }
}
