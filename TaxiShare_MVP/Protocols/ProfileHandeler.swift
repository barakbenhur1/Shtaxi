//
//  ProfileHandeler.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/09/2024.
//

import SwiftUI

protocol ProfileHandeler: View {
    var buttonEnabled: Bool { get }
    var externalActionLoading: Bool? { get }
    func preformAction(complete: @escaping (Bool) -> ())
}
