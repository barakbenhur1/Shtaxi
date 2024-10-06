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

struct MapView: View {
    //MARK: - Properties
    @EnvironmentObject private var launchScreenManager: LaunchScreenStateManager
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(followsHeading: true, 
                                                                         fallback: .automatic)
    @State private var isShowSideMenu: Bool = false
    @State private var isSheetOpen: Bool = true
    @State private var routes: [MKRoute]?
    @State private var routeParamters: [RouteParamters]?
    @State private var destnationView: DestanationSearchView?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Map(position: $cameraPosition) {
                if let routes {
                    ForEach(routes, id: \.self) { route in
                        MapPolyline(route)
                            .stroke(Color.tBlue, lineWidth: 5)
                    }
                }
                
                if let routeParamters {
                    ForEach(routeParamters, id: \.self) { paramter in
                        if let location = paramter.from.location {
                            Annotation(paramter.from.title, coordinate: location.coordinate) {
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
                        }
                        
                        if let location = paramter.to.location {
                            Annotation(paramter.from.title, coordinate: location.coordinate) {
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
            }
            .onTapGesture { withAnimation { isSheetOpen = false } }
            .overlay { CustomSheetView(open: $isSheetOpen) { MapSheetView { view in destnationView = view } } }
            //            .mapControls {
//                MapUserLocationButton()
//                    .mapControlVisibility(.visible)
//                MapCompass()
//                    .buttonBorderShape(.circle)
//                MapScaleView()
//                    .buttonBorderShape(.circle)
//            }
//            .controlSize(.large)
            .onChange(of: routeParamters) {
                guard let routeParamters else { return }
                guard let routeParamter = routeParamters.first else { return }
                guard let location = routeParamter.from.location else { return }
                getDirections()
                let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 500, longitudeDelta: 500))
                withAnimation { cameraPosition = .region(region) }
            }
            
            ButtonWithShadow(image: "menu") { isShowSideMenu.toggle() }
                .padding(.top, 84)
                .padding(.trailing, 20)
            
            if let destnationView {
                destnationView
                    .transition(.move(edge: .bottom))
                    .environmentObject(locationManager)
            }
            
            SideMenu(isShowing: $isShowSideMenu,
                     title: menuTitle(),
                     content: menuList(),
                     edge: .trailing)
            .ignoresSafeArea()
        }
        .onAppear { locationManager.checkLocationAuthorization() }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func getDirections() {
        routes = nil
        guard let routeParamters else { return }
        
        Task {
            var r = [MKRoute]()
            for paramter in routeParamters {
                guard let coordinate = paramter.from.location?.coordinate else { return }
                guard let to = paramter.to.location?.coordinate else { return }
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

#Preview {
    MapView()
}
