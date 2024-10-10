//
//  CLLocation+EXT.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 09/10/2024.
//

import CoreLocation

extension CLLocation {
    var string: String {
        return "\(coordinate.latitude),\(coordinate.longitude)"
    }
}
