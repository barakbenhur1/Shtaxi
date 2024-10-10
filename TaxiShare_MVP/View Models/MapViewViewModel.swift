//
//  MapViewVM.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 30/06/2024.
//

import SwiftUI
import MapKit

struct City: Identifiable, Hashable {
    var id = UUID()
    let name: String
    let location: CLLocation
}

@Observable
final class MapViewViewModel: ViewModel {
    internal let useCases = MapUseCases(repo: MapRepositoryImpl(dataSource: MapDataSource()))
    
    let locationManager = LocationManager()
    
    var trips: [TripModel] = []
    var cities: [City] = []
    var routes: [MKRoute]?
    var routeParamters: [RouteParamters]?
    
    func newTrip(id: String, fromBody: TripBody, toBody: TripBody, number: Int, complition: @escaping () -> (), error: @escaping (String) -> ()) {
        useCases.newTrip(id: id, fromBody: fromBody, toBody: toBody, number: number, complition: complition, error: error)
    }
    
    func getTrips() {
        useCases.getTrips { tripsValue in
            Task { [weak self] in
                guard let self else { return }
                var c = [City]()
                for trip in tripsValue {
                    let cityName = trip.from.city
                    guard !c.contains(where: { city in cityName == city.name }) else { continue }
                    guard let location = await getCoordinate(addressString: cityName) else { continue }
                    c.append(.init(name: cityName,
                                   location: location))
                }
                
                await MainActor.run { [c, tripsValue] in
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        trips = tripsValue
                        cities = c
                    }
                }
            }
        } error: { error in print(error) }
    }
    
    func getCoordinate(addressString : String) async -> CLLocation? {
        return await withCheckedContinuation({ c in
            getCoordinate(addressString: addressString) { location, error in
                guard error == nil else { return c.resume(returning: nil) }
                return c.resume(returning: CLLocation(latitude: location.latitude, longitude: location.longitude))
            }
        })
    }
    
    func getCoordinate(addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func getDirections() {
        routes = nil
        guard let routeParamters else { return }
        
        Task {
            var r = [MKRoute]()
            for paramter in routeParamters {
                let coordinate = paramter.from.location.coordinate
                let to = paramter.to.location.coordinate
                let selectedResult = MKMapItem(placemark: .init(coordinate: to))
                
                let request = MKDirections.Request ()
                request.source = MKMapItem(placemark: MKPlacemark (coordinate: coordinate))
                request.destination = selectedResult
                let directions = MKDirections(request: request)
                let response = try? await directions.calculate()
                guard let route = response?.routes.first else { continue }
                r.append(route)
            }
            
            routes = r
        }
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void) {
        // Use the last reported location.
        if let lastLocation = locationManager.lastKnownLocation {
            lookupLocation(location: CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude),
                           completionHandler: completionHandler)
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    func lookupLocation(location: CLLocation?, completionHandler: @escaping (CLPlacemark?) -> Void) {
        guard let location else { return completionHandler(nil) }
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
                // An error occurred during geocoding.
                completionHandler(nil)
            }
        })
    }
}

