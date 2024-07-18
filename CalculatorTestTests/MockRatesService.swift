//
//  MockRatesService.swift
//  CalculatorTestTests
//
//  Created by Chernov Kostiantyn on 17.07.2024.
//

import Foundation
import Combine
@testable import CalculatorTest

class MockRatesService: RatesService {
    var exchangeRateResult: Result<RateModel, Error>?
    
    func getExchangeRate(from: String, to: String, amount: Double) -> AnyPublisher<RateModel, Error> {
        if let result = exchangeRateResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
    }
}
