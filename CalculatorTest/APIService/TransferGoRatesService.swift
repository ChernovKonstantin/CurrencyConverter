//
//  TransferGoRatesService.swift
//  CalculatorTest
//
//  Created by Chernov Kostiantyn on 15.07.2024.
//

import Foundation
import Combine

class TransferGoRatesService: RatesService {
    private let baseURL = "https://my.transfergo.com/api/fx-rates"
    
    func getExchangeRate(from: String, to: String, amount: Double) -> AnyPublisher<RateModel, Error> {
        let fromParam = "?from="+from
        let toParam = "&to="+to
        let amountParam = "&amount="+String(amount)
        guard let url = URL(string: baseURL+fromParam+toParam+amountParam) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { responseBody in
                guard let response = responseBody.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return responseBody.data
            }
            .decode(type: RateModel.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                return error
            }
            .eraseToAnyPublisher()
    }
}
