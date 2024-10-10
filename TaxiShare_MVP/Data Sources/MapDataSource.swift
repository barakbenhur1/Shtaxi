//
//  MapDataSource.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import Foundation

class MapDataSource: Network, MapRepository {
    override internal var root: String { return "map" }
    
    private let handeler = ComplitionHandeler()
    private let pHandeler = ParameterHndeler()
    
    // MARK: newTrip
    /// - Parameters:
    ///  - id - user id
    ///  - fromBody: Trip Start
    ///  - toBody: Trip end
    ///  - complition
    ///  - error
    func newTrip(id: String, fromBody: TripBody, toBody: TripBody, number: Int, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        let validComplition = handeler.makeValid(complition) as (EmptyModel) -> ()
        let userIdBody = UserIdBody(id: id)
        var parameters = pHandeler.toDict(values: userIdBody)
        parameters["from"] = pHandeler.toDict(values: fromBody)
        parameters["to"] = pHandeler.toDict(values: toBody)
        parameters["numberOfPassengers"] = number
        send(method: .post,
             route: "new",
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
    
    // MARK: getTrips
    /// - Parameters:
    ///  - complition
    ///  - error
    func getTrips(complition: @escaping ([TripModel]) -> (), error: @escaping (String) -> ()) {
        let validComplition = handeler.makeValid(complition)
        let parameters = [String : Any]()
        send(method: .post,
             route: "getTrips",
             parameters: parameters,
             complition: validComplition,
             error: error)
    }
}
