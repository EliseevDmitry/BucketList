//
//  Model.swift
//  BucketList
//
//  Created by Dmitriy Eliseev on 23.07.2024.
//

import Foundation
import CoreLocation

struct Location: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}


struct Result: Codable {
    let query: Query
}


struct Query: Codable {
    let pages: [Int: Page]
}


struct Page: Codable, Comparable  {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String{
        terms?["description"]?.first ?? "No further information"
    }
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}

enum LoadingState {
    case loading, loaded, failed
}
