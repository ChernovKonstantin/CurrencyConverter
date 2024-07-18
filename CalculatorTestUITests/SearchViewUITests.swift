//
//  SearchViewUITests.swift
//  CalculatorTestUITests
//
//  Created by Chernov Kostiantyn on 17.07.2024.
//

import XCTest

class SearchViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testSearchViewUI() {
        let initialCountry = CountryModel(name: "Poland", currencyCode: "PLN", currencyName: "Polish zloty", currencyLimit: 20000)
        let searchableCountry = CountryModel(name: "Germany", currencyCode: "EUR", currencyName: "Euro", currencyLimit: 5000)
        let initialAmount = "300.00"
        let inputTitle = "Sending from"
        
        let titleLabel = app.staticTexts[inputTitle]
        XCTAssertTrue(titleLabel.exists)
        
        let amountTextField = app.textFields[inputTitle]
        XCTAssertTrue(amountTextField.exists)
        XCTAssertEqual(amountTextField.value as? String, initialAmount)
        
        let countrySelectionButton = app.buttons[initialCountry.currencyCode]
        XCTAssertTrue(countrySelectionButton.exists)
        countrySelectionButton.tap()
        
        let searchViewTitleLabel = app.staticTexts["All countries"]
        XCTAssertTrue(searchViewTitleLabel.exists)
        
        let testCountryCell = app.cells.staticTexts[searchableCountry.name]
        XCTAssertTrue(testCountryCell.exists)
        testCountryCell.tap()
        
        let searchableCountryButton = app.buttons[searchableCountry.currencyCode]
        XCTAssertTrue(searchableCountryButton.exists)
    }
}
