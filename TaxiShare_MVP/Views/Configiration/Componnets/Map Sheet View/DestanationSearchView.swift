//
//  DestanationSearchView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/10/2024.
//

import SwiftUI
import Combine
import MapKit

struct DestanationSearchView: View {
    @EnvironmentObject private var locationManager: LocationManager
    
    enum SerachField: Int, Hashable {
        case field
    }
    
    let image: String
    let placeHolder: String
    @State var text: String
    let didSelect: (SearchCompletions?) -> ()
    
    @State private var locationService = LocationService()
    
    @FocusState private var focusedField: SerachField?
    
    var body: some View {
        VStack {
            HStack {
                ButtonWithShadow(image: "back") {
                    hideKeyboard()
                    didSelect(nil)
                }
                Spacer()
            }
            .padding(.top, 84)
            .padding(.bottom, 5)
            
            textField()
                .onReceive(Just(text)) { _ in locationService.update(queryFragment: text) }
                .focused($focusedField,
                         equals: .field)
            
            List {
                Section {
                    Text("מיקום נוכחי")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            hideKeyboard()
                            lookUpCurrentLocation { place in
                                guard let place else { return }
                                guard let title = place.name else { return }
                                guard let location = place.location else { return }
                                didSelect(.init(title: title, subTitle: place.description, location: location))
                            }
                        }
                }
                
                Section {
                    ForEach(locationService.completions, id: \.self) { serach in
                        VStack(alignment: .center) {
                            Text(serach.title)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                            Text(serach.subTitle)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.all, 12)
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            hideKeyboard()
                            didSelect(serach)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal, 20)
        .background(.white)
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .onTapGesture { hideKeyboard() }
        .onAppear {
            focusedField = .field
            locationService.update(queryFragment: text)
        }
    }
    
    private func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void) {
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
    
    private func lookupLocation(location: CLLocation?, completionHandler: @escaping (CLPlacemark?) -> Void) {
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
    
    @ViewBuilder private func textField() -> some View {
        HStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .frame(width: 24)
                .padding(.leading, 24)
                .padding(.trailing, 4)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                }
                .foregroundColor(.secondary)
                .padding(.trailing, 4)
                .frame(height: 18)
                .frame(width: 18)
            }
            
            TextField(placeHolder,
                      text: $text)
            .font(.textMedium)
            .multilineTextAlignment(.trailing)
            .autocorrectionDisabled()
            .padding(.trailing, 24)
        }
        .frame(height: 52)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.infoText,
                        lineWidth: 1)
        )
    }
}

//#Preview {
//    DestanationSearchView()
//}
