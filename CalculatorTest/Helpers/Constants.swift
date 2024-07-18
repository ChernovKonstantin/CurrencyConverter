//
//  Constants.swift
//  CalculatorTest
//
//  Created by Chernov Kostiantyn on 15.07.2024.
//

import Foundation

class Constants {
    static let shared = Constants()
    
    private init() { }
    
    let countries: [CountryModel] = [
        CountryModel(name: "Poland", currencyCode: "PLN", currencyName: "Polish zloty", currencyLimit: 20000),
        CountryModel(name: "Ukraine", currencyCode: "UAH", currencyName: "Hrivna", currencyLimit: 50000),
        CountryModel(name: "Germany", currencyCode: "EUR", currencyName: "Euro", currencyLimit: 5000),
        CountryModel(name: "Great Britain", currencyCode: "GBP", currencyName: "British Pound", currencyLimit: 1000)
    ]
    
}
