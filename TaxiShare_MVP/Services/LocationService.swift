//
//  LocationService.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/06/2024.
//

import MapKit

struct SearchCompletions: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subTitle: String
    let location: CLLocation
}

@Observable
class LocationService: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter
    
    var completions: [SearchCompletions]
    
    override init() {
        self.completer = .init()
        self.completions = [SearchCompletions]()
        super.init()
        self.completer.delegate = self
        self.completer.resultTypes = .address
    }
    
    func update(queryFragment: String) {
        completer.queryFragment = queryFragment
        guard !queryFragment.isEmpty else { return completions = [] }
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        var c = [SearchCompletions]()
        for result in completer.results {
            guard let mapItem = result.value(forKey: "_mapItem") as? MKMapItem else { continue }
            guard let location = mapItem.placemark.location else { continue }
            c.append(.init(title: result.title,
                           subTitle: result.subtitle,
                           location: location))
        }
        completions = c
    }
}
