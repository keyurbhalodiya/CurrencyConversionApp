//
//  SelectedCurrencyRowView.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import SwiftUI

struct CurrencyRowViewModel: Hashable {
  let baseCurrencyCode: String
  let quoteCurrencyCode: String
  let quoteCurrencyFlag: String
  let quoteCurrencyName: String
  let amount: Double
  let rate: Double
}

struct SelectedCurrencyRowView: View {
  
  private let rowModel: CurrencyRowViewModel
  
  init(rowModel: CurrencyRowViewModel) {
    self.rowModel = rowModel
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("\(rowModel.quoteCurrencyCode) \(rowModel.quoteCurrencyFlag)")
          .font(.system(size: 18, weight: .medium, design: .default))
        Text(rowModel.quoteCurrencyName)
          .font(.system(size: 14, weight: .regular, design: .default))
      }
      Spacer()
      VStack(alignment: .trailing) {
        Text(String(format: "%.2f", rowModel.amount))
          .font(.system(size: 18, weight: .medium, design: .default))
        Text("1 \(rowModel.baseCurrencyCode) = \(String(format: "%.2f", rowModel.rate)) \(rowModel.quoteCurrencyCode)")
          .font(.system(size: 14, weight: .regular, design: .default))
      }
    }
    .padding()
  }
}

#Preview {
  SelectedCurrencyRowView(rowModel: CurrencyRowViewModel(
    baseCurrencyCode: "SGD",
    quoteCurrencyCode: "USD",
    quoteCurrencyFlag: "🇺🇸",
    quoteCurrencyName: "US Dollar",
    amount: 1000,
    rate: 0.74)
  )
}
