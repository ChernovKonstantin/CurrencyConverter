//
//  MainViewModel.swift
//  CalculatorTest
//
//  Created by Chernov Kostiantyn on 15.07.2024.
//

import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var sendingAmount: String = "300.00"
    @Published var receiverGets: String = "300.00"
    @Published var exchangeRate: Double = 1.0
    @Published var senderViewStyle: CountryInputViewStyle = .primary
    @Published var sendingCountry: CountryModel = Constants.shared.countries[0]
    @Published var receivingCountry: CountryModel = Constants.shared.countries[1]
    
    private var isUpdatingFromSendingAmount = false
    private var isUpdatingFromReceiverGets = false
    private let exchangeRateService: RatesService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(ratesService: RatesService = TransferGoRatesService()) {
        self.exchangeRateService = ratesService
        subscribeToSendingAmountChange()
        subscribeToReceiverAmountChange()
        subscribeToCountryChange()
        guard let value = Double(sendingAmount) else { return }
        fetchExchangeRates(amount: value, forSender: true)
    }
    
    func swapCurrencies() {
        let tempCountry = sendingCountry
        sendingCountry = receivingCountry
        receivingCountry = tempCountry
        validateAmount()
    }
    
    func validateAmount() {
        guard let amountNum = Double(sendingAmount) else { return }
        self.senderViewStyle = amountNum < sendingCountry.currencyLimit ? .primary : .limitExceed
    }
    
    func fetchExchangeRates(amount: Double, forSender: Bool) {
        self.isLoading = true
        let fromCurrency = forSender ? sendingCountry.currencyCode : receivingCountry.currencyCode
        let toCurrency = forSender ? receivingCountry.currencyCode : sendingCountry.currencyCode
        
        exchangeRateService.getExchangeRate(from: fromCurrency, to: toCurrency, amount: amount)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("Error fetching exchange rate: \(error)")
                    self.isLoading = false
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self, let rate = response.rate, let toAmount = response.toAmount 
                else {
                    self?.isLoading = false
                    return
                }
                self.exchangeRate = rate
                if forSender {
                    self.receiverGets = String(format: "%.2f", toAmount)
                } else {
                    self.sendingAmount = String(format: "%.2f", toAmount)
                }
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    private func subscribeToSendingAmountChange() {
        $sendingAmount
            .dropFirst()
            .sink { [weak self] value in
                guard let self, let value = Double(value), value != Double(self.sendingAmount) else { return }
                if !self.isUpdatingFromReceiverGets && !isLoading {
                    self.isUpdatingFromSendingAmount = true
                    self.fetchExchangeRates(amount: value, forSender: true)
                    self.isUpdatingFromSendingAmount = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToCountryChange() {
        Publishers.Merge($sendingCountry, $receivingCountry)
            .dropFirst(2)
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self, let value = Double(sendingAmount) else { return }
                if !self.isUpdatingFromReceiverGets && !isLoading {
                    self.isUpdatingFromSendingAmount = true
                    self.fetchExchangeRates(amount: value, forSender: true)
                    self.isUpdatingFromSendingAmount = false
                }
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToReceiverAmountChange() {
        $receiverGets
            .dropFirst()
            .sink { [weak self] value in
                guard let self, let value = Double(value), value != Double(self.receiverGets) else { return }
                if !self.isUpdatingFromSendingAmount && !isLoading {
                    self.isUpdatingFromReceiverGets = true
                    self.fetchExchangeRates(amount: value, forSender: false)
                    self.isUpdatingFromReceiverGets = false
                }
            }
            .store(in: &cancellables)
    }
}
