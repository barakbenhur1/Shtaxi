//
//  MapRepository.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation

protocol MapRepository {
    func newTrip(id: String, fromBody: TripBody, toBody: TripBody, number: Int, complition: @escaping () -> (), error: @escaping (String) -> ())
    func getTrips(complition: @escaping ([TripModel]) -> (), error: @escaping (String) -> ())
}
