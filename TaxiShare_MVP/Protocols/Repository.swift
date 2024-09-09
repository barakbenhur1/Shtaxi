//
//  Repository.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 09/09/2024.
//

import Foundation

protocol Repository {
    associatedtype DS = DataSource
    var dataSource: DS { get }
}
