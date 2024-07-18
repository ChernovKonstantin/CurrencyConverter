//
//  SearchViewModel.swift
//  CalculatorTest
//
//  Created by Chernov Kostiantyn on 15.07.2024.
//

import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Published var countriesList: [CountryModel] = Constants.shared.countries
    @Published var searchText: String = ""
    @Published var filteredCountries: [CountryModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.filterCountries(for: searchText)
            }
            .store(in: &cancellables)
    }
    
    func filterCountries(for searchText: String) {
        guard !searchText.isEmpty else {
            filteredCountries = countriesList
            return
        }
        filteredCountries = countriesList.filter {  $0.name.lowercased().contains(searchText.lowercased()) }
    }
}
