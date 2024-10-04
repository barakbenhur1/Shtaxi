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
    let location: CLLocation?
    var url: URL?
    var confirmed: Bool = false
    var time: Date?
}

struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let location: CLLocationCoordinate2D
    let title: String

    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Observable
class LocationService: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter
    private var query: String
    
    var completions: [SearchCompletions]
    
    override init() {
        self.completer = .init()
        self.completions = [SearchCompletions]()
        self.query = ""
        super.init()
        self.completer.delegate = self
        self.completer.resultTypes = .pointOfInterest
    }
    
    func update(queryFragment: String) {
        self.query = queryFragment
        guard !queryFragment.isEmpty else { return completions = [] }
        completer.queryFragment = queryFragment
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard !query.isEmpty else { return }
        completions = completer.results.map { completion in
            // Get the private _mapItem property
            let mapItem = completion.value(forKey: "_mapItem") as? MKMapItem
            
            return .init(
                title: completion.title,
                subTitle: completion.subtitle,
                location: mapItem?.placemark.location,
                url: mapItem?.url
            )
        }
    }
}
