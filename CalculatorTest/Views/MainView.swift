//
//  MainView.swift
//  CalculatorTest
//
//  Created by Chernov Kostiantyn on 15.07.2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            VStack {
                senderView
                buttonsView
                receiverView
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.2))
                    .padding()
            )
            .frame(height: 275)
            if viewModel.senderViewStyle == .limitExceed {
                limitExceeWarningView
            }
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .controlSize(.large)
                    .tint(.black)
                    .padding()
            }
            Spacer()
        }
    }
    
    private var senderView: some View {
        return CountryInputView(viewStyle: $viewModel.senderViewStyle, country: $viewModel.sendingCountry, amount: $viewModel.sendingAmount, inputTitle: "Sending from")
            .shadow(color: Color.black.opacity(0.5), radius: 10)
            .onChange(of: viewModel.sendingAmount) {
                withAnimation { viewModel.validateAmount() }
            }
    }
    
    private var receiverView: some View {
        return CountryInputView(viewStyle: .constant(.secondary), country: $viewModel.receivingCountry, amount: $viewModel.receiverGets, inputTitle: "Receiver gets")
    }
    
    @ViewBuilder
    private var buttonsView: some View {
        HStack {
            Button(action: {
                viewModel.swapCurrencies()
            }, label: {
                Image("swap_icon")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.horizontal, 40)
            })
            Text("1 \(viewModel.sendingCountry.currencyCode) = \(String(format: "%.2f", viewModel.exchangeRate)) \(viewModel.receivingCountry.currencyCode)")
                .padding(.horizontal)
                .background(Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.vertical, -20)
    }
    
    @ViewBuilder
    private var limitExceeWarningView: some View {
        HStack {
            Image(systemName: "info.circle")
            Text("Maximum sending amount: \(viewModel.sendingCountry.currencyLimit) "+viewModel.sendingCountry.currencyCode)
            Spacer()
        }
        .padding(5)
        .font(.system(size: 15))
        .background(Color.red.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .foregroundStyle(.red.opacity(0.7))
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
