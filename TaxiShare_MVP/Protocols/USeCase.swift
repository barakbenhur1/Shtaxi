//
//  USeCase.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 09/09/2024.
//

import Foundation

protocol USeCase {
    associatedtype R = Repository
    var repo: R { get }
}
