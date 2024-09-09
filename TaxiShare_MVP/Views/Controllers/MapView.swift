//
//  MapView.swift
//  Taxi_MVP
//
//  Created by Barak Ben Hur on 26/06/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var vmProvider: ViewModelProvider
    @EnvironmentObject private var profileSync: ProfileSyncHendeler
//    @EnvironmentObject private var manager: CoreDataManager
  
    @FetchRequest(sortDescriptors: []) private var profiles: FetchedResults<Profile>
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var locationService = LocationService(completer: .init())
    @State private var postion: MapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)))
    @State private var startPosition: CLLocation = .init()
    @State private var searchResults: [SearchResult] = []
    @State private var endText: String = ""
    @State private var startText: String = "start place"
    @State private var isShowSideMenu: Bool = false
    @State private var isShowAlert: Bool = false
    @State private var isShowDelete = false
    @State private var anotations: [SearchCompletions] = []
    
    @State private var selection: Int?
    
    @State private var taxiTimes: [Date] = []
    
    @FocusState private var startFocused: Bool {
        didSet {
            guard startFocused else { return }
            locationService.update(queryFragment: startText)
        }
    }
    
    @FocusState private var endFocused: Bool {
        didSet {
            guard endFocused else { return }
            locationService.update(queryFragment: endText)
        }
    }
    
    private var onboardingVM: OnboardingViewModel {
        return vmProvider.vm()
    }
    
    private var mapVM: MapViewViewModel {
        return vmProvider.vm()
    }
    
    private func navigateTo(route: Router.Route) {
        router.navigateTo(route)
    }
    
    private func profileImage() -> UIImage {
        if let data = profiles.last?.image {
            return UIImage(data: data)!
        }
        else {
            return UIImage(named: "logo")!
        }
    }
    
    private func list() -> some View {
        List {
            ForEach(locationService.completions, id: \.self) { item in
                Button(item.title) {
                    if let location = item.location?.coordinate {
                        let location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                        if endFocused {
                            mapVM.endPositionValue = item
                            isShowAlert = true
                            postion = MapCameraPosition.region(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)))
                            endText = ""
                        }
                        else if startFocused {
                            startPosition = item.location!
                            startText = item.title
                            mapVM.startPositionValue = item
                        }
                        startFocused = false
                        endFocused = false
                    }
                }
            }
        }
        .frame(maxHeight: 500)
        .frame(width: 360)
        .clipShape(RoundedRectangle(cornerSize: .init(width: 10, height: 10)))
        .zIndex(2)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $postion, selection: $selection) {
                ForEach(anotations) { result in
                    Marker(coordinate: result.location?.coordinate ?? .init()) {
                        VStack {
                            if result.confirmed {
                                Text(result.title)
                                    .font(.caption)
                                Text(result.subTitle)
                                    .font(.caption)
                                if let time = result.time?.formatted(date: .numeric, time: .shortened) {
                                    Text("\(time)")
                                        .font(.caption)
                                }
                            }
                            else {
                                Text("לאישור והזנת פרטים לחץ")
                                    .font(.caption)
                            }
                        }
                    }
                    .tag(anotations.firstIndex(of: result)!)
                    .tint(result.confirmed ? .red : .white.opacity(0.6))
                }
            }
            .onChange(of: selection) {
                guard let selection else {
                    mapVM.sheetValue = nil
                    return
                }
                mapVM.sheetValue = selection
            }
            .mapStyle(.hybrid)
            .ignoresSafeArea()
            .onTapGesture {
                startFocused = false
                endFocused = false
                isShowSideMenu = false
                mapVM.sheetValue = nil
                selection = nil
                
                startText = mapVM.startPositionValue?.title ?? ""
            }
            
            ZStack {
                VStack {
                    Text("Shtaxi".localized())
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding(.bottom, 8)
                    HStack {
                        navigtionButton {
                            navigationButtonText("תפריט",
                                                 bold: true)
                        } action: {
                            isShowSideMenu.toggle()
                        }
                        
                        Spacer()
                        
                        navigtionButton {
                            navigationButtonText("פילטור")
                        } action: {
                            isShowSideMenu = false
                            router.navigateTo(.filter)
                        }
                        .padding(.leading, 20)
                    }
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 58)
                .padding(.bottom, 20)
            }
            .background(Color.tYellow.opacity(0.98))
            .clipShape(UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 10, bottomTrailing: 10)))
            .ignoresSafeArea()
            
            if !locationService.completions.isEmpty {
                if startFocused {
                    list()
                        .padding(.top, 190)
                }
                else if endFocused {
                    list()
                        .padding(.top, 285)
                }
            }
            
            ZStack {
                VStack {
                    //                    TextFiledView(label: "איסוף", text: $startText, focus: { value in
                    //                        guard value else { return }
                    //                        locationService.completions = []
                    //                        locationService.update(queryFragment: startText)
                    //                    })
                    //                    .padding(.top, 200)
                    //                    .onChange(of: startText) {
                    //                        locationService.update(queryFragment: startText)
                    //                    }
                    //                    .focused($startFocused)
                    
                    //                    Image("downArrow")
                    //                        .resizable()
                    //                        .frame(height: 40)
                    //                        .frame(width: 40)
                    
                    //                    TextFiledView(label: "יעד", text: $endText) { value in
                    //                        guard value else { return }
                    //                        locationService.completions = []
                    //                        locationService.update(queryFragment: endText)
                    //                    }
                    //                    .onChange(of: endText) {
                    //                        locationService.update(queryFragment: endText)
                    //                    }
                    //                    .focused($endFocused)
                }
            }
            .ignoresSafeArea()
            .onAppear {
                if let location = locationManager.location {
                    startPosition = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    postion = MapCameraPosition.region(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
                    Task {
                        let name = try? await locationService.search(with: "", coordinate: location).first?.title
                        startText = name ?? ""
                    }
                }
            }
            
            SideMenu(isShowing: $isShowSideMenu,
                     title: menuTitle(),
                     content: menuList())
            .ignoresSafeArea()
        }
        .customAlert("מחיקת פרופיל",
                     isPresented:  $isShowDelete,
                     actionText: "כן, מחק",
                     cancelButtonText: "לא",
                     action: deleteProfile)
        {
            Text("האם אתה בטוח?".localized())
        }
        .alert("בקשה לנסיעה".localized(), isPresented: $isShowAlert, actions: {
            Button(action: {
                anotations.append(mapVM.endPositionValue!)
                taxiTimes.append(Date())
            }, label: {
                Text("כן".localized())
            })
            
            Button(action: {
                isShowAlert = false
            }, label: {
                Text("לא".localized())
            })
        }, message: {
            let text = {
                if anotations.contains(where: { item in
                    return item.title == mapVM.endPositionValue?.title }) {
                    return "קיימות נסיעות למקום זה\nהאם ברצונך ליצר אחת חדשה בכל זאת?"
                }
                else {
                    return "לא קיימות נסיעות למקום זה\nהאם ברצונך ליצר אחת?"
                }
            }()
            Text(text)
        })
        .sheet(isPresented: vmProvider.bindVm().isShowSheet) {
            VStack(alignment: .trailing) {
                Text("נוסעים")
                    .font(.headline)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                HStack {
                    Image(uiImage: profileImage())
                        .resizable()
                        .clipShape(Circle())
                        .background(.white)
                        .frame(width: 40)
                        .frame(height: 40)
                }
                .padding(.bottom, 30)
                
                if let sheetValue = mapVM.sheetValue {
                    Text("\("איסוף") \(mapVM.startPositionValue!.title)")
                        .font(.title)
                        .padding(.bottom, 20)
                    Text("\("יעד:") \(anotations[sheetValue].title)")
                        .font(.title)
                        .padding(.bottom, 20)
                    
                    HStack(spacing: 10) {
                        DatePicker(selection: $taxiTimes[sheetValue]) {
                            
                        }
                        Text("שעת יציאה:")
                            .font(.title)
                    }
                    .padding(.bottom ,20)
                    
                    Button(action: {
                        anotations[sheetValue].time = taxiTimes[sheetValue]
                        anotations[sheetValue].confirmed = true
                        mapVM.isShowSheet = false
                    }, label: {
                        Text("אישור".localized())
                    })
                    .font(.title2)
                    .padding(.bottom ,30)
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .presentationDetents([.height(400)])
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
                         config: .init(buttonConfig: .regular(bold: false,
                                                              dimantions: .full,
                                                              enabled: true))) { isShowSideMenu = false }
            }
            
            menuItem(text: "התנתקות".localized(),
                     config: .init(buttonConfig: .regular(bold: true,
                                                          dimantions: .full,
                                                          enabled: true))) {
                isShowSideMenu = false
                if let profile = profiles.last, let id = profile.userID {
                    onboardingVM.logout(id: id) {
                        profileSync.removeAndPopToLogin(profile: profile)
                    } error: { error in print(error) }
                }
                else { router.popToRoot() }
            }
                                                          .padding(.top, 5)
            
            VStack {
                separator()
                
                menuItem(text: "מחיקת פרופיל".localized(),
                         config: .init(buttonConfig: .critical(dimantions: .full,
                                                               enabled: true))) {
                    isShowSideMenu = false
                    isShowDelete = true
                }
                                          .padding(.top, 10)
                                          .padding(.bottom, 10)
            }
            .padding(.top, 5)
        }
    }
    
    private func deleteProfile() {
        guard let profile = profiles.last else { return  router.popToRoot() }
        guard let id = profile.userID else { return  router.popToRoot() }
        onboardingVM.delete(id: id) {
            profileSync.removeAndPopToLogin(profile: profile)
        } error: { error in
            profileSync.removeAndPopToLogin(profile: profile)
            print(error)
        }
    }
    
    @ViewBuilder private func navigationButtonText(_ text: String, bold: Bool = false) -> some View {
        Text(text)
            .padding(.all, 8)
            .font( bold ? .caption2.bold() : .caption2)
            .foregroundStyle(.black)
    }
    
    @ViewBuilder private func navigtionButton(@ViewBuilder label: () -> some View, action: @escaping () -> ()) -> some View {
        Button(action: {
            action()
        }, label: {
            label()
        })
        .frame(width: 50)
        .frame(height: 50)
        .background(.white)
        .clipShape(Circle())
    }
    
    @ViewBuilder private func separator() -> some View {
        ZStack { Color.gray.opacity(0.3) }
        .frame(height: 1)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder private func menuItem(text: String, config: TButtonConfigManager, didTap: @escaping () -> ()) -> some View {
        TButton(text: text,
                config: config.buttonConfig) {
            didTap()
        }
                .listRowSeparator(.hidden)
    }
}

//                ForEach(anotations, id: \.self) { item in
//                    Button(action: {
//                        isShowSideMenu = false
//                        let l2d = CLLocationCoordinate2D(latitude: item.location!.coordinate.latitude, longitude: item.location!.coordinate.longitude)
//                        postion =  MapCameraPosition.region(MKCoordinateRegion(center: l2d, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
//                        viewModel.sheetValue = anotations.firstIndex(of: item)
//                    }, label: {
//                        VStack(alignment: .leading) {
//                            Text(item.title)
//                                .font(.largeTitle)
//                                .foregroundStyle(.black)
//                            Text(item.subTitle)
//                                .font(.subheadline)
//                                .foregroundStyle(.secondary)
//                        }
//                    })
//                }

#Preview {
    MapView()
}
