//
//  ViewModelProvider.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 09/09/2024.
//

import SwiftUI

class ViewModelProvider: ObservableObject {
    static let shared = ViewModelProvider()
    
    private typealias ViewModelMap = [String: any ViewModel]
    
    @Published private var vmMap: ViewModelMap
    
    private init() { vmMap = ViewModelMap() }
    func vm<VM: ViewModel>() -> VM { return viewModelFor(key: "\(VM.self)") }
    
    private func viewModelFor<VM: ViewModel>(key: String) -> VM {
       if vmMap[key] == nil { vmMap[key] = VM.init() }
       return vmMap[key] as! VM
   }
}
