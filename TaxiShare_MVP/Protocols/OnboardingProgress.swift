//
//  Onboarding.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 28/08/2024.
//

import SwiftUI

protocol OnboardingProgress: ProfileUpdater {
    var noActionNeeded: (() -> ())? { get }
    var complition: ((_ enable: Bool) -> ())? { get }
    var otherAction: (() -> ())? { get }
}
