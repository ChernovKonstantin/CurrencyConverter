//
//  CountryInputView.swift
//  CalculatorTest
//
//  Created by Chernov Kostiantyn on 15.07.2024.
//

import SwiftUI

enum CountryInputViewStyle {
    case primary
    case secondary
    case limitExceed
    
    var backgroundColor: Color {
        switch self {
        case .primary, .limitExceed: return .white
        case .secondary: return .clear
        }
    }
    
    var textColor: Color {
        switch self {
        case .primary: return .blue
        case .secondary: return .black
        case .limitExceed: return .red
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary, .secondary: return .clear
        case .limitExceed: return .red
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .primary, .limitExceed: return 20
        case .secondary: return 0
        }
    }
}

struct CountryInputView: View {
    @Binding var viewStyle: CountryInputViewStyle
    
    @Binding var country: CountryModel
    @Binding var amount: String
    
    @State private var showingSheet = false
    
    var inputTitle: String
    
    var body: some View {
        ZStack {
            viewStyle.backgroundColor
            HStack {
                VStack(alignment: .leading) {
                    Text(inputTitle)
                        .foregroundStyle(.gray)
                    Button(action: {
                        showingSheet.toggle()
                    }, label: {
                        HStack{
                            Image(country.currencyCode+"_icon")
                            Text(country.currencyCode)
                                .foregroundStyle(.black)
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.gray)
                        }
                    })
                    .sheet(isPresented: $showingSheet) {
                        SearchView(country: $country, screenTitle: inputTitle)
                    }
                }
                Spacer()
                TextField(inputTitle, text: $amount)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(viewStyle.textColor)
            }
            .padding()
            
        }
        .clipShape(RoundedRectangle(cornerRadius: viewStyle.cornerRadius))
        .overlay(content: { RoundedRectangle(cornerRadius: viewStyle.cornerRadius)
                .stroke(viewStyle.borderColor, lineWidth: 3)
        })
        
        
    }
}

#Preview {
    CountryInputView(viewStyle: .constant(.limitExceed), country: .constant(CountryModel(name: "Ukraine", currencyCode: "UAH", currencyName: "Hrivna", currencyLimit: 50000)), amount: .constant("100.00"), inputTitle: "Sending from")
}
