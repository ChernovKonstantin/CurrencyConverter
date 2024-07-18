//
//  CountrySearchView.swift
//  CalculatorTest
//
//  Created by Chernov Kostiantyn on 15.07.2024.
//

import SwiftUI

struct CountrySearchView: View {
    
    var country: CountryModel
    
    var body: some View {
        HStack() {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                Image(country.currencyCode+"_icon")
            }
            VStack(alignment: .leading) {
                Text(country.name)
                    .bold()
                Text("\(country.currencyName) • \(country.currencyCode)")
            }
            Spacer()
        }
    }
}

#Preview {
    CountrySearchView(country: CountryModel(name: "Ukraine", currencyCode: "UAH", currencyName: "Hrivna", currencyLimit: 50000))
}
