//
//  ExchangeRateView.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import SwiftUI

protocol ExchangeRateViewState: ObservableObject {
  var rowModel: [CurrencyRowViewModel] { get }
  var exchangeRates: [String: Double] { get }
  var baseCurrencyCode: String { get }
  var quoteCurrencyCode: String { get }
  var baseCurrencyAmount: Double { get set }
  var quoteCurrencyAmount: Double { get set }
}

protocol ExchangeRateViewListner {
  func loadConversionRates()
  func didTappedSwapping()
  func updateCurrencyAmount(for type: CurrencyType, with amount: Double)
  func updateCurrencyCode(for type: CurrencyType, with currencyCode: String)
  func addCurrency(newCurrencyCode: String)
  func removeCurrency(currencyCode: String)
}

typealias ConversionRateViewModel = ExchangeRateViewState & ExchangeRateViewListner

struct ExchangeRateView<ViewModel: ConversionRateViewModel>: View {

  @StateObject private var viewModel: ViewModel
  @State private var number: Double = 1000
  
  public init(viewModel: ViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
    var body: some View {
      NavigationView {
        VStack {
          Divider()
            .padding(.bottom)
          VStack {
            CurrencyAmountTextField(amount: $viewModel.baseCurrencyAmount, currencyCode: viewModel.baseCurrencyCode)
              .onChange(of: viewModel.baseCurrencyAmount) { newValue in
                viewModel.updateCurrencyAmount(for: .baseCurrency, with: newValue)
              }
            swappingButton
            CurrencyAmountTextField(amount: $viewModel.quoteCurrencyAmount, currencyCode: viewModel.quoteCurrencyCode)
              .onChange(of: viewModel.quoteCurrencyAmount) { newValue in
                viewModel.updateCurrencyAmount(for: .quoteCurrncy, with: newValue)
              }
          }
          .frame(maxWidth: UIScreen.main.bounds.size.width - 32)
          .background(Color.white)
          .cornerRadius(15)
          .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
          .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
          .padding(.bottom)
          
          List(viewModel.rowModel, id: \.self) { rowModel in
            SelectedCurrencyRowView(rowModel: rowModel)
          }
          .listStyle(.plain)
        }
        .onAppear {
          viewModel.loadConversionRates()
        }
        .navigationTitle("Currency Conveter")
        .toolbar {
          Button("Add") {}
        }
        .navigationBarTitleDisplayMode(.inline)
      }
    }
  
  
  @ViewBuilder
  var swappingButton: some View {
    Button(action: {
      viewModel.didTappedSwapping()
    }) {
      Image(systemName: "rectangle.2.swap")
    }
    .frame(width: 30, height: 30)
  }
}

// MARK: Preview

#if DEBUG
private final class ExchangeRateViewModelMock: ConversionRateViewModel {
  var rowModel: [CurrencyRowViewModel] = [
    CurrencyRowViewModel(baseCurrencyCode: "SGD", quoteCurrencyCode: "USD", quoteCurrencyFlag: "USD".countryFlag(), quoteCurrencyName: "USD".currencyName(), amount: 100 * 0.74, rate: 0.74),
    CurrencyRowViewModel(baseCurrencyCode: "SGD", quoteCurrencyCode: "AED", quoteCurrencyFlag: "AED".countryFlag(), quoteCurrencyName: "AED".currencyName(), amount: 100 * 3.6725, rate: 3.6725),
    CurrencyRowViewModel(baseCurrencyCode: "SGD", quoteCurrencyCode: "AFN", quoteCurrencyFlag: "AFN".countryFlag(), quoteCurrencyName: "AFN".currencyName(), amount: 100 * 71.0480, rate: 71.0480)
  ]
 
  var exchangeRates: [String : Double] = ["USD" : 1, "AED" : 3.6725, "AFN" : 71.0480, "ALL" : 93.6300, "AMD" : 388.1220]
  
  var baseCurrencyCode: String = "SGD"
  
  var quoteCurrencyCode: String = "USD"
  
  var baseCurrencyAmount: Double = 1000
  
  var quoteCurrencyAmount: Double = 736.55
 
  func loadConversionRates() { }
  func didTappedSwapping() { }
  func updateCurrencyAmount(for type: CurrencyType, with amount: Double) { }
  func updateCurrencyCode(for type: CurrencyType, with currencyCode: String) { }
  func addCurrency(newCurrencyCode: String) { }
  func removeCurrency(currencyCode: String) { }
}
#Preview {
  ExchangeRateView(viewModel: ExchangeRateViewModelMock())
}

#endif
