//
//  MapUseCases.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation

struct MapUseCases: USeCase, MapRepository {
    let repo: MapRepository
    
    func newTrip(id: String, fromBody: TripBody, toBody: TripBody, number: Int, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        repo.newTrip(id: id, fromBody: fromBody, toBody: toBody, number: number, complition: complition, error: error)
    }
    
    func getTrips(complition: @escaping ([TripModel]) -> (), error: @escaping (String) -> ()) {
        repo.getTrips(complition: complition, error: error)
    }
}
