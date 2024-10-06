//
//  LocationMnager.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/06/2024.
//
import Foundation
import CoreLocation
import _MapKit_SwiftUI

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    @Published var position: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0,
                                                                                                                                 longitude: 0),
                                                                                                  span: MKCoordinateSpan(latitudeDelta: 0.006,
                                                                                                                         longitudeDelta: 0.006)))
    var manager = CLLocationManager()
    
    func checkLocationAuthorization() {
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            manager.requestWhenInUseAuthorization()
            
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Location restricted")
            
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied")
            
        case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
            print("Location authorizedAlways")
            
        case .authorizedWhenInUse://This authorization allows you to use all location services and receive location events only when your app is in use
            print("Location authorized when in use")
            lastKnownLocation = manager.location?.coordinate
            
        @unknown default:
            print("Location service disabled")
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        
        guard let lastKnownLocation else { return }
        position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lastKnownLocation.latitude,
                                                                                                   longitude: lastKnownLocation.longitude),
                                                                    span: MKCoordinateSpan(latitudeDelta: 0.006,
                                                                                           longitudeDelta: 0.006)))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        lastKnownLocation = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        
        guard let lastKnownLocation else { return }
        position = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lastKnownLocation.latitude,
                                                                                                   longitude: lastKnownLocation.longitude),
                                                                    span: MKCoordinateSpan(latitudeDelta: 0.006,
                                                                                           longitudeDelta: 0.006)))
    }
}
