//
//  TripBody.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 09/10/2024.
//

import Foundation
import CoreLocation

struct TripBody: DictionaryRepresentable, Codable, Hashable {
    let city: String
    let street: String
    let locationRepresentation: String
    
    var location: CLLocation {
        let representation = locationRepresentation.components(separatedBy: ",").map { Double($0)! }
        return CLLocation(latitude: representation[0], longitude: representation[1])
    }
}
