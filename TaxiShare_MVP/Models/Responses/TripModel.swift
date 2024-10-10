//
//  TripModel.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 09/10/2024.
//

import Foundation

struct TripModel: Codable, Hashable {
    let _id: String
    let managerID: String
    let from: TripBody
    let to: TripBody
    let additional: [TripBody]
    let numberOfPassengers: Int
}
