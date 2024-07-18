//
//  CountryModel.swift
//  CalculatorTestUITests
//
//  Created by Chernov Kostiantyn on 17.07.2024.
//

import Foundation

struct CountryModel: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let currencyCode: String
    let currencyName: String
    let currencyLimit: Double
}
