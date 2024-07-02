//
//  ExchangeRateViewModel.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import Foundation
import Combine

protocol CacheDataProviding {
  var cacheCurrencies: [String] { get }
  var baseCurrencyCode: String { get }
  var quoteCurrencyCode: String { get }
  func addCurrency(newCurrencyCode: String)
  func removeCurrency(currencyCode: String)
  func updateCurrencyCode(code: String, for type: CurrencyType)
}

protocol NetworkDataProviding {
  var conversionRatesPublisher: AnyPublisher<[String: Double], Never> { get }
  func loadConversionRate()
}

final class ExchangeRateViewModel: ConversionRateViewModel {
  
  // MARK: Dependencies
  private let dataProvider: DataProviding
  
  @Published var exchangeRates: [String: Double] = [:]
  
  init(dataProvider: DataProviding) {
    self.dataProvider = dataProvider
  }
  
  var baseCurrencyCode: String {
    dataProvider.baseCurrencyCode
  }
  
  var quoteCurrencyCode: String {
    dataProvider.quoteCurrencyCode
  }
  
  func loadConversionRates() {
    dataProvider.loadConversionRate()
  }
}
