//
//  RateModel.swift
//  CalculatorTest
//
//  Created by Chernov Kostiantyn on 15.07.2024.
//

import Foundation

struct RateModel: Decodable {
    let from: String?
    let to: String?
    let rate: Double?
    let fromAmount: Double?
    let toAmount: Double?
}
