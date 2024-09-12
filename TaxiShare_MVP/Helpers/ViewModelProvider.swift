//
//  ViewModelProvider.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 09/09/2024.
//

import SwiftUI

class ViewModelProvider: Singleton {
    private typealias ViewModelChase = [String: any ViewModel]
    
    private var chase: ViewModelChase
    
    private override init() { chase = ViewModelChase() }
    
    func viewModel<VM: ViewModel>() -> VM { return viewModelFor(value: VM.self) }
    
    private func viewModelFor<VM: ViewModel>(value: any ViewModel.Type) -> VM {
        let key = "\(value)"
        if chase[key] == nil { chase[key] = VM() }
        return chase[key] as! VM
    }
}
