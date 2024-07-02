//
//  ExchangeRateView.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import SwiftUI

protocol ExchangeRateViewState: ObservableObject {
  var exchangeRates: [String: Double] { get }
  var baseCurrencyCode: String { get }
  var quoteCurrencyCode: String { get }
}

protocol ExchangeRateViewListner {
  func loadConversionRates()
}

typealias ConversionRateViewModel = ExchangeRateViewState & ExchangeRateViewListner

struct ExchangeRateView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ExchangeRateView()
}
