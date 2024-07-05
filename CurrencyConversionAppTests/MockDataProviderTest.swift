//
//  MockDataProviderTest.swift
//  CurrencyConversionAppTests
//
//  Created by Keyur Bhalodiya on 2024/07/04.
//

import XCTest
import Combine
@testable import CurrencyConversionApp

final class MockDataProvider: DataProviding {
    var cacheCurrencies: [String] = ["USD", "EUR", "GBP", "JPY"]
    var baseCurrencyCode: String = "USD"
    var quoteCurrencyCode: String = "EUR"
    
    @Published var conversionRates: [String: Double] = [:]
  
    var conversionRatesPublisher: AnyPublisher<[String: Double], Never> {
      return $conversionRates.eraseToAnyPublisher()
    }
    
    func addCurrency(newCurrencyCode: String) {
        cacheCurrencies.append(newCurrencyCode)
    }
    
    func removeCurrency(currencyCode: String) {
        cacheCurrencies.removeAll { $0 == currencyCode }
    }
    
    func updateCurrencyCode(code: String, for type: CurrencyType) {
        if type == .baseCurrency {
            baseCurrencyCode = code
        } else {
            quoteCurrencyCode = code
        }
    }
    
    func loadConversionRate(for baseCurrency: String) {
      conversionRates = Helper.loadLocalTestDataWithoutParsing("ExchangeRate", type: ExchangeRateInfo.self)?.conversionRates ?? [:]
    }
}
