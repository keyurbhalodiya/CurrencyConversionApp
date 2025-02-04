//
//  CurrencyAmountTextField.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import SwiftUI

struct CurrencyAmountTextField: View {
  
  @Binding var amount: Double?
  private let currencyCode: String
  private let tapHander: () -> Void
  @FocusState private var isFocused: Bool

  init(amount: Binding<Double?>, currencyCode: String, tapHander: @escaping () -> Void) {
    self._amount = amount
    self.currencyCode = currencyCode
    self.tapHander = tapHander
  }
  
  var body: some View {
    HStack() {
      HStack {
        Button(action: {
          tapHander()
        }) {
          Text("\(currencyCode) " + currencyCode.countryFlag())
            .multilineTextAlignment(.center)
          Image(systemName: "chevron.down")
        }
      }
      Spacer()
      TextField("", value: $amount, format: .number .grouping(.never) .precision(.fractionLength(2)))
        .keyboardType(.decimalPad)
        .padding(10)
        .overlay(RoundedRectangle(cornerRadius: 5)
          .stroke(Color.gray)
        )
        .focused($isFocused)
        .toolbar {
          if isFocused {
            ToolbarItemGroup(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button(action: {
                        isFocused = false
                    }) { Text("Done") }
                }
            }
          }
        }
    }
    .foregroundColor(.black)
    .font(.system(size: 20, weight: .medium, design: .default))
    .padding()
  }
}


#if DEBUG
private struct MockView: View {
  
  @State var amount: Double? = 10000
  
  var body: some View {
    CurrencyAmountTextField(amount: $amount, currencyCode: "SGD", tapHander: { })
  }
}

#Preview {
  MockView()
}
#endif
