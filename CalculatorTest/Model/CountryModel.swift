//
//  CountryModel.swift
//  CalculatorTest
//
//  Created by Chernov Kostiantyn on 15.07.2024.
//

import Foundation

struct CountryModel: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let currencyCode: String
    let currencyName: String
    let currencyLimit: Double
}
