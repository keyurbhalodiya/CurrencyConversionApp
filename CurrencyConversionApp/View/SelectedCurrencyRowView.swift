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
          Text(rowModel.quoteCurrencyName)
            .font(.system(size: 12, weight: .light, design: .default))
        }
        Spacer()
        VStack(alignment: .trailing) {
          Text(rowModel.amount, format: .number)
          Text("1 \(rowModel.baseCurrencyCode) = \(rowModel.rate) \(rowModel.quoteCurrencyCode)")
            .font(.system(size: 12, weight: .light, design: .default))
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
