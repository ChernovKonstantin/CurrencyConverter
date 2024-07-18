//
//  RatesService.swift
//  CalculatorTest
//
//  Created by Chernov Kostiantyn on 15.07.2024.
//

import Combine

protocol RatesService {
    func getExchangeRate(from: String, to: String, amount: Double) -> AnyPublisher<RateModel, Error>
}
