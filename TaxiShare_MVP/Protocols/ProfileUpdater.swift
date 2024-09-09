//
//  GenericView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/08/2024.
//

import SwiftUI

protocol ProfileUpdater: View {
    func preformAction(profile: Profile?, complete: @escaping (_ valid: Bool) -> ())
}
