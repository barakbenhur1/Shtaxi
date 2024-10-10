//
//  MapView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 30/09/2024.
//

import SwiftUI
import MapKit

struct RouteParamters: Hashable {
    let from: SearchCompletions
    let to: SearchCompletions
}

struct MapView<VM: MapViewViewModel>: View {
    //MARK: - Properties
    @EnvironmentObject private var router: Router
    
    @State private var vm = VM()
    @State private var destnationView: DestanationSearchView?
    @State private var isShowSideMenu: Bool = false
    @State private var isSheetOpen: Bool = true
    @State private var cameraPosition: MapCameraPosition = .userLocation(followsHeading: true,
                                                                         fallback: .automatic)
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $cameraPosition) {
                ForEach(vm.cities, id: \.self) { city in
                    Annotation("", coordinate: city.location.coordinate) {
                        ZStack(alignment: .center) {
                            Image("CityMarker")
                                .resizable()
                                .frame(height: 87)
                                .frame(width: 80)
                           
                            Text(city.name)
                                .font(.textMediumSemiBold)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.gBlack)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                        }
                        .frame(height: 87)
                        .frame(width: 80)
                    }
                }
                
                //                ForEach(vm.trips, id: \.self) { trip in
                //
                //                }
                //
                
                if let routes = vm.routes {
                    ForEach(routes, id: \.self) { route in
                        MapPolyline(route)
                            .stroke(Color.tBlue, lineWidth: 5)
                    }
                }
                
                if let routeParamters = vm.routeParamters {
                    ForEach(routeParamters, id: \.self) { paramter in
                        Annotation(paramter.from.title, coordinate: paramter.from.location.coordinate) {
                            ZStack {
                                Image(systemName: "noUser") /// user image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 20)
                                    .frame(width: 20)
                            }
                            .frame(height: 20)
                            .frame(width: 20)
                            .cornerRadius(10, corners: .allCorners)
                        }
                        
                        Annotation(paramter.from.title, coordinate: paramter.to.location.coordinate) {
                            ZStack {
                                if paramter == routeParamters.last {
                                    Circle()
                                        .background(Color.tBlue)
                                    
                                }
                                else {
                                    Image(systemName: "noUser") /// user image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 20)
                                        .frame(width: 20)
                                }
                            }
                            .frame(height: 20)
                            .frame(width: 20)
                            .cornerRadius(10, corners: .allCorners)
                        }
                    }
                }
            }
            .overlay {
                CustomSheetView(open: $isSheetOpen) {
                    MapSheetView(showDestenationSearchView: { view in destnationView = view },
                                 trip: { from, to, number, filters in
                        let from = TripBody(city: from.city,
                                            street: from.street,
                                            locationRepresentation: from.location.string)
                        
                        let to = TripBody(city: to.city,
                                          street: to.street,
                                          locationRepresentation: to.location.string)
                        
                        router.navigateTo(.trip(from: from,
                                                to: to,
                                                number: number,
                                                filters: filters))
                    })
                }
            }
            .onTapGesture { withAnimation { isSheetOpen = false } }
            .onChange(of: vm.routeParamters) {
                guard let routeParamters = vm.routeParamters else { return }
                guard let routeParamter = routeParamters.first else { return }
                let location = routeParamter.from.location
                vm.getDirections()
                let region = MKCoordinateRegion(center: location.coordinate,
                                                span: MKCoordinateSpan(latitudeDelta: 500,
                                                                       longitudeDelta: 500))
                withAnimation { cameraPosition = .region(region) }
            }
            
            ButtonWithShadow(image: "menu",
                             didSelect: { isShowSideMenu.toggle() })
            .padding(.top, 84)
            .padding(.trailing, 20)
            
            if let destnationView { destnationView }
            
            SideMenu(isShowing: $isShowSideMenu,
                     title: menuTitle(),
                     content: menuList(),
                     edge: .trailing)
            .ignoresSafeArea()
        }
        .onAppear {
            vm.locationManager.checkLocationAuthorization()
            vm.getTrips()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder private func menuTitle() -> some View {
        Text("תפריט".localized())
            .multilineTextAlignment(.center)
            .font(.title)
            .foregroundStyle(.gray.opacity(0.6))
    }
    
    @ViewBuilder private func menuList() -> some View {
        List {
            ForEach(1..<8, id: \.self) { i in
                menuItem(text: "אופצייה \(i)".localized(),
                         config: .init(config: .regular(bold: false,
                                                        dimantions: .full,
                                                        enabled: true)))
                {
                    isShowSideMenu = false
                    // preform action
                }
            }
            .padding(.bottom, 2)
            
            menuItem(text: "התנתקות".localized(),
                     config: .init(config: .regular(bold: true,
                                                    dimantions: .full,
                                                    enabled: true)))
            {
                //                isShowLogout = true
                isShowSideMenu = false
            }
            
            VStack {
                separator()
                
                menuItem(text: "מחיקת פרופיל".localized(),
                         config: .init(config: .critical(dimantions: .full,
                                                         enabled: true)))
                {
                    isShowSideMenu = false
                    //                    isShowDelete = true
                }
                .padding(.top, 2)
                .padding(.bottom, 2)
            }
            .padding(.top, 3)
        }
    }
    
    @ViewBuilder private func menuItem(text: String, config: TButtonConfigManager, didTap: @escaping () -> ()) -> some View {
        TButton(text: text,
                config: config.config) {
            didTap()
        }
                .listRowSeparator(.hidden)
    }
    
    @ViewBuilder private func separator() -> some View {
        ZStack { Color.gray.opacity(0.3) }
            .frame(height: 1)
            .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    MapView()
//}
