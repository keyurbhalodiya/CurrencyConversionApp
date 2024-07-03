//
//  ContentView.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    let dataProvider = DataProvider(repo: ExchangeRateRepository())
    let viewModel = ExchangeRateViewModel(dataProvider: dataProvider)
    ExchangeRateView(viewModel: viewModel)
  }
}

#Preview {
    ContentView()
}
