//
//  ViewModelProvider.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 09/09/2024.
//

import SwiftUI

class ViewModelProvider: ObservableObject {
    static let shared = ViewModelProvider()
    
    @Published private var onboardingVM = OnboardingViewModel()
    @Published private var mapVM = MapViewViewModel()
    
    private init() {}
    
    func vm() -> OnboardingViewModel {
        return onboardingVM
    }
    
    func vm() -> MapViewViewModel {
        return mapVM
    }
    
    func bindVm() -> Binding<OnboardingViewModel> {
        return onboardingVM.binding()
    }
    
    func bindVm() -> Binding<MapViewViewModel> {
        return mapVM.binding()
    }
}
