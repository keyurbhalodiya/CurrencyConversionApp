//
//  CurrencyAmountTextField.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import SwiftUI

struct CurrencyAmountTextField: View {
  
  @Binding var amount: Double
  private let currencyCode: String
  
  init(amount: Binding<Double>, currencyCode: String) {
    self._amount = amount
    self.currencyCode = currencyCode
  }
  
  var body: some View {
    HStack() {
      HStack {
        Button(action: {
        }) {
          Text("\(currencyCode) " + currencyCode.countryFlag())
            .multilineTextAlignment(.center)
          Image(systemName: "chevron.down")
        }
      }
      Spacer()
      TextField("", value: $amount, format: .number)
        .padding(10)
        .overlay(RoundedRectangle(cornerRadius: 5)
          .stroke(Color.gray)
        )
    }
    .foregroundColor(.black)
    .font(.system(size: 20, weight: .medium, design: .default))
    .padding()

  }
}


#if DEBUG
private struct MockView: View {
  
  @State var amount: Double = 10000

  var body: some View {
    CurrencyAmountTextField(amount: $amount, currencyCode: "SGD")
  }
}

#Preview {
  MockView()
}
#endif
