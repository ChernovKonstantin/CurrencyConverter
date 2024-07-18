//
//  MainViewUITests.swift
//  CalculatorTestUITests
//
//  Created by Chernov Kostiantyn on 17.07.2024.
//

import XCTest
@testable import CalculatorTest

final class MainViewTests: XCTestCase {
    
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
    
    func testMainViewUI() {
        XCTAssertTrue(app.staticTexts["Sending from"].exists)
        XCTAssertTrue(app.staticTexts["Receiver gets"].exists)
        XCTAssertTrue(app.buttons["swap_icon"].exists)
        
        let initialSenderText = app.textFields["Sending from"]
        XCTAssertTrue(initialSenderText.exists)
    }
    
    func testMainViewSwapButtonUI() {
        let initialSenderText = app.textFields["Sending from"].value as? String
        let initialReceiverText = app.textFields["Receiver gets"].value as? String
        
        app.buttons["swap_icon"].tap()
        
        let swappedSenderText = app.textFields["Receiver gets"].value as? String
        let swappedReceiverText = app.textFields["Sending from"].value as? String
        
        XCTAssertEqual(initialSenderText, swappedReceiverText)
        XCTAssertEqual(initialReceiverText, swappedSenderText)
    }
    
    
}

