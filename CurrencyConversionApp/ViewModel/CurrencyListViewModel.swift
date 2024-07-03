//
//  CurrencyListViewModel.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/03.
//

import Foundation

final class CurrencyListViewModel: CurrencySelectionViewModel {
  // MARK: Dependencies
  private let currencies: [String]
  @Published var filterCurrencies: [String] = []

  internal init(currencies: [String]) {
    self.currencies = currencies
    self.filterCurrencies = self.currencies
  }
}

// MARK: CurrencyListViewModel + CurrencyListViewListener

extension CurrencyListViewModel {
  
  func didSearchCurrency(with searchText: String) {
    filterCurrencies = currencies.filter({ $0.localizedCaseInsensitiveContains(searchText) })
  }
  
  func didCancelSearchCurrency() {
    filterCurrencies = currencies
  }
}
