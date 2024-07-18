//
//  SearchView.swift
//  CalculatorTest
//
//  Created by Chernov Kostiantyn on 15.07.2024.
//

import SwiftUI
import Combine

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = SearchViewModel()
    
    @Binding var country: CountryModel
    
    var screenTitle: String
    
    var body: some View {
        VStack(spacing: 0) {
            Text(screenTitle)
                .font(.largeTitle)
                .bold()
                .padding(.top)
            NavigationStack {
                if viewModel.searchText.isEmpty {
                    HStack {
                        Text("All countries")
                        Spacer()
                    }
                    .font(.title2)
                    .bold()
                    .padding(.horizontal)
                }
                List(viewModel.filteredCountries, id: \.id) { country in
                    CountrySearchView(country: country)
                        .onTapGesture {
                            self.country = country
                            dismiss()
                        }       
                }
                .listStyle(.plain)
                Spacer()
            }
            .searchable(text: $viewModel.searchText, prompt: "Search country")
        }
    }
}

#Preview {
    SearchView(country: .constant(CountryModel(name: "Ukraine", currencyCode: "UAH", currencyName: "Hrivna", currencyLimit: 50000)), screenTitle: "Sending to")
}
