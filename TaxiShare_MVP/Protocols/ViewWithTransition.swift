//
//  ViewWithTransition.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 01/09/2024.
//

import SwiftUI

protocol ViewWithTransition: View {
    var transitionAnimation: Bool { get }
}
