//
//  ExchangeRateRepository.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import Foundation
import Combine

enum CurrencyType {
  case baseCurrency
  case quoteCurrncy
}

final class ExchangeRateRepository: CacheDataProviding {
  
  private enum Constant {
    static let baseCurrencyCodeKey: String = "baseCurrencyCodeKey"
    static let quoteCurrencyKey: String = "quoteCurrencyKey"
    static let selectedCurrenciesKey: String = "selectedCurrenciesKey"
  }
  
  static let shared = ExchangeRateRepository()
  private let userDefault = UserDefaults.standard

  init() { }
  
  private func updateCache(shouldAdd: Bool = true, currencyCode: String) {
    var cacheData = cacheCurrencies
    if shouldAdd {
      cacheData.append(currencyCode)
    } else {
      cacheData.removeAll { code in
        code == currencyCode
      }
    }
    userDefault.setValue(cacheData, forKey: Constant.selectedCurrenciesKey)
  }
  
  private func updateBaseOrQuoteCurrencyCode(currencyCode: String, for key: String) {
    userDefault.setValue(currencyCode, forKey: key)
  }
}

// MARK: CacheDataProviding

extension ExchangeRateRepository {
  var cacheCurrencies: [String] {
    guard let cacheData = userDefault.object(forKey: Constant.selectedCurrenciesKey) as? [String] else {
      return ["SGD"]
    }
    return cacheData
  }
  
  var baseCurrencyCode: String {
    guard let cacheData = userDefault.string(forKey: Constant.baseCurrencyCodeKey) else {
      return "SGD"
    }
    return cacheData
  }
  
  var quoteCurrencyCode: String {
    guard let cacheData = userDefault.string(forKey: Constant.quoteCurrencyKey) else {
      return "USD"
    }
    return cacheData
  }
  
  func addCurrency(newCurrencyCode: String) {
    updateCache(currencyCode: newCurrencyCode)
  }
  
  func removeCurrency(currencyCode: String) {
    updateCache(shouldAdd: false, currencyCode: currencyCode)
  }
  
  func updateCurrencyCode(code: String, for type: CurrencyType) {
    updateBaseOrQuoteCurrencyCode(currencyCode: code, for: type == .baseCurrency ? Constant.baseCurrencyCodeKey : Constant.quoteCurrencyKey)
  }
}
