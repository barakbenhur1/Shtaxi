//
//  DestanationSearchView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/10/2024.
//

import SwiftUI
import Combine
import MapKit

struct DestanationSearch {
    let city: String
    let street: String
    let location: CLLocation
}

struct DestanationSearchView: View {
    @EnvironmentObject private var vmProvider: ViewModelProvider
    
    @State private var locationService = LocationService()
    
    private var vm: MapViewViewModel { return vmProvider.viewModel() }
    
    enum SerachField: Int, Hashable {
        case field
    }
    
    private let queue = DispatchQueue.main
    
    let image: String
    let placeHolder: String
    @State var text: String
    let didSelect: (DestanationSearch?) -> ()
    
    @State private var isAnimating = false
    
    @FocusState private var focusedField: SerachField?
    
    var body: some View {
        VStack {
            HStack {
                ButtonWithShadow(image: "back") {
                    hideKeyboard()
                    withAnimation(.spring) { isAnimating = false }
                    queue.asyncAfter(wallDeadline: .now() + 0.5) { didSelect(nil) }
                }
                Spacer()
            }
            .padding(.top, 84)
            .padding(.bottom, 5)
            
            textField()
                .focused($focusedField,
                         equals: .field)
            
            List {
                Section {
                    Text("מיקום נוכחי")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            hideKeyboard()
                            withAnimation(.spring) { isAnimating = false }
                            vm.lookUpCurrentLocation { place in
                                guard let place else { return }
                                guard let city = place.locality else { return }
                                guard let street = place.subLocality else { return }
                                guard let location = place.location else { return }
                                queue.asyncAfter(wallDeadline: .now() + 0.5) { didSelect(.init(city: city,
                                                                                                street: street,
                                                                                                location: location)) }
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
                            withAnimation(.spring) { isAnimating = false }
                            vm.lookupLocation(location: serach.location) { place in
                                guard let place else { return }
                                guard let city = place.locality else { return }
                                queue.asyncAfter(wallDeadline: .now() + 0.5) { didSelect(.init(city: city,
                                                                                               street: serach.title,
                                                                                               location: serach.location)) }
                            }
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
        .offset(y: isAnimating ? 0 : UIScreen.main.bounds.height)
        .opacity(isAnimating ? 1 : 0)
        .onChange(of: text) { locationService.update(queryFragment: text) }
        .onAppear {
            focusedField = .field
            locationService.update(queryFragment: text)
            withAnimation(.spring) { isAnimating = true }
        }
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
