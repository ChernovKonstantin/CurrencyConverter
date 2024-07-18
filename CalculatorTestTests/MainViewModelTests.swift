//
//  MainViewModelTests.swift
//  CalculatorTestTests
//
//  Created by Chernov Kostiantyn on 17.07.2024.
//

import XCTest
import Combine
@testable import CalculatorTest

class MainViewModelTests: XCTestCase {
    var viewModel: MainViewModel!
    var mockRatesService: MockRatesService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRatesService = MockRatesService()
        viewModel = MainViewModel(ratesService: mockRatesService)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockRatesService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialValues() {
        XCTAssertEqual(viewModel.sendingAmount, "300.00")
        XCTAssertEqual(viewModel.receiverGets, "300.00")
        XCTAssertEqual(viewModel.exchangeRate, 1.0)
        XCTAssertEqual(viewModel.senderViewStyle, .primary)
        XCTAssertEqual(viewModel.sendingCountry, Constants.shared.countries[0])
        XCTAssertEqual(viewModel.receivingCountry, Constants.shared.countries[1])
    }
    
    func testFetchExchangeRatesSuccess() {
        let response = RateModel(from: nil,
                                 to: nil,
                                 rate: 1.2,
                                 fromAmount: nil,
                                 toAmount: 360)
        mockRatesService.exchangeRateResult = .success(response)
        
        let expectation = self.expectation(description: "Fetch exchange rates")
        
        var fulfillCalled = false
        
        viewModel.$receiverGets
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value, "360.00")
                if !fulfillCalled {
                    fulfillCalled = true
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchExchangeRates(amount: 300, forSender: true)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchExchangeRatesFailure() {
        let error = NSError(domain: "TestError", code: 1, userInfo: nil)
        mockRatesService.exchangeRateResult = .failure(error)
        
        let expectation = self.expectation(description: "Fetch exchange rate fail")
        
        var fulfillCalled = false
        
        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading, !fulfillCalled {
                    fulfillCalled = true
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetchExchangeRates(amount: 300, forSender: true)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSwapCurrencies() {
        let initialSendingCountry = viewModel.sendingCountry
        let initialReceivingCountry = viewModel.receivingCountry
        
        viewModel.swapCurrencies()
        
        XCTAssertEqual(viewModel.sendingCountry, initialReceivingCountry)
        XCTAssertEqual(viewModel.receivingCountry, initialSendingCountry)
        XCTAssertEqual(viewModel.sendingAmount, viewModel.receiverGets)
    }
    
    func testValidateAmount() {
        viewModel.sendingAmount = "200.00"
        viewModel.validateAmount()
        XCTAssertEqual(viewModel.senderViewStyle, .primary)
        
        viewModel.sendingAmount = "50000.00"
        viewModel.validateAmount()
        XCTAssertEqual(viewModel.senderViewStyle, .limitExceed)
    }
}
