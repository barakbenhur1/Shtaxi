//
//  MapView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 30/09/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    //MARK: - Properties
    @EnvironmentObject private var launchScreenManager: LaunchScreenStateManager
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var isShowSideMenu: Bool = false
    @State private var isSheetOpen: Bool = true
    
    @State private var destnationView: DestanationSearchView? = nil
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let location = locationManager.lastKnownLocation {
                let position =  MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude,
                                                                                                           longitude: location.longitude),
                                                                            span: MKCoordinateSpan(latitudeDelta: 0.006,
                                                                                                   longitudeDelta: 0.006)))
                Map(position: .constant(position))
                    .onTapGesture { isSheetOpen = false }
                    .overlay {
                        CustomSheetView(open: $isSheetOpen) { MapSheetView { view in destnationView = view } }
                    }
            }
            
            Button {
                isShowSideMenu.toggle()
            } label: {
                Image("menu")
            }
            .padding(.top, 56)
            .padding(.trailing, 40)
            .frame(height: 52)
            .frame(width: 52)
            
            if let destnationView {
                destnationView
                    .transition(.move(edge: .bottom))
            }
            
            SideMenu(isShowing: $isShowSideMenu,
                     title: menuTitle(),
                     content: menuList(),
                     edge: .trailing)
            .ignoresSafeArea()
        }
        .onAppear { locationManager.checkLocationAuthorization() }
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
