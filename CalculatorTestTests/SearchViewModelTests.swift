//
//  SearchViewModelTests.swift
//  CalculatorTestTests
//
//  Created by Chernov Kostiantyn on 17.07.2024.
//

import XCTest
import Combine
@testable import CalculatorTest

class SearchViewModelTests: XCTestCase {

    var viewModel: SearchViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testFilterCountries_EmptySearchText() throws {
        let expectedCountries = Constants.shared.countries
        let expectation = self.expectation(description: "debounce expectation")
        
        viewModel.$searchText
            .dropFirst() // Drop initial value to avoid the initial debounce
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                XCTAssertEqual(self?.viewModel.filteredCountries, expectedCountries)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchText = ""
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFilterCountries_NonEmptySearchText() throws {
        let searchText = "Ukraine"
        let expectedFilteredCountries = Constants.shared.countries.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        let expectation = self.expectation(description: "debounce expectation")
        
        viewModel.$searchText
            .dropFirst() // Drop initial value to avoid the initial debounce
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                XCTAssertEqual(self?.viewModel.filteredCountries, expectedFilteredCountries)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchText = searchText
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testDebouncing() throws {
        let expectation = self.expectation(description: "debounce expectation")
        
        viewModel.$searchText
            .dropFirst() // Drop initial value to avoid the initial debounce
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .sink { searchText in
                XCTAssertEqual(searchText, "Ukraine")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchText = "Ukraine"
        
        wait(for: [expectation], timeout: 1.0)
    }

}
