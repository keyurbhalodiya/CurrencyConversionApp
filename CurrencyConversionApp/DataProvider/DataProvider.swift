//
//  DataProvider.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import Foundation
import Combine

typealias DataProviding = CacheDataProviding & NetworkDataProviding

final class DataProvider: DataProviding {
  
  // MARK: Dependencies
  private let repo: CacheDataProviding

  private var cancellables: Set<AnyCancellable> = Set()
  @Published private var conversionRates: [String: Double] = [:]
  
  init(repo: CacheDataProviding) {
    self.repo = repo
  }
}

// MARK: CacheDataProviding

extension DataProvider {
  
  var cacheCurrencies: [String] {
    repo.cacheCurrencies
  }
  
  var baseCurrencyCode: String {
    repo.baseCurrencyCode
  }
  
  var quoteCurrencyCode: String {
    repo.quoteCurrencyCode
  }
  
  func addCurrency(newCurrencyCode: String) {
    repo.addCurrency(newCurrencyCode: newCurrencyCode)
  }
  
  func removeCurrency(currencyCode: String) {
    repo.removeCurrency(currencyCode: currencyCode)
  }
  
  func updateCurrencyCode(code: String, for type: CurrencyType) {
    repo.updateCurrencyCode(code: code, for: type)
  }
}

// MARK: NetworkDataProviding

extension DataProvider {
  
  var conversionRatesPublisher: AnyPublisher<[String : Double], Never> {
    $conversionRates.eraseToAnyPublisher()
  }
  
  func loadConversionRate(for baseCurrency: String) {
    NetworkService.shared.getData(baseCurrency: baseCurrency, type: ExchangeRateInfo.self)
      .sink { completion in
        switch completion {
        case .failure(let err):
          print("Error is \(err.localizedDescription)")
        case .finished:
          print("Finished successfully")
        }
      } receiveValue: { [weak self] rateInfo in
        guard let conversionRates = rateInfo.conversionRates else { return }
        self?.conversionRates = conversionRates
      } .store(in: &cancellables)
  }
}
