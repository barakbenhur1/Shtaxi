//
//  MapRepositoryImpl.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation

struct MapRepositoryImpl: Repository, MapRepository {
    let dataSource: MapRepository
    
    func newTrip(id: String, fromBody: TripBody, toBody: TripBody, number: Int, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        dataSource.newTrip(id: id, fromBody: fromBody, toBody: toBody, number: number, complition: complition, error: error)
    }
    
    func getTrips(complition: @escaping ([TripModel]) -> (), error: @escaping (String) -> ()) {
        dataSource.getTrips(complition: complition, error: error)
    }
}
