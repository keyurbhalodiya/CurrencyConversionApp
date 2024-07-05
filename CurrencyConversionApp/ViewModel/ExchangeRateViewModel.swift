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
  func loadConversionRate(for baseCurrency: String)
}

final class ExchangeRateViewModel: ConversionRateViewModel {
  
  // MARK: Dependencies
  private let dataProvider: DataProviding
  
  private var cancellables: Set<AnyCancellable> = Set()
  
  private(set) var exchangeRates: [String: Double] = [:]
  @Published private(set) var baseCurrencyCode: String
  @Published private(set) var quoteCurrencyCode: String
  @Published private(set) var rowModel: [CurrencyRowViewModel] = []
  @Published var baseCurrencyAmount: Double? = 1000
  @Published var quoteCurrencyAmount: Double? = 0
  @Published var isLoading: Bool = false

  var quoteCurrencyRate: String {
    guard let rate = exchangeRates[quoteCurrencyCode] else { return "" }
    return "1 \(baseCurrencyCode) = \(String(format: "%.2f", rate)) \(quoteCurrencyCode)"
  }
  
  init(dataProvider: DataProviding) {
    self.dataProvider = dataProvider
    self.baseCurrencyCode = dataProvider.baseCurrencyCode
    self.quoteCurrencyCode = dataProvider.quoteCurrencyCode
    subscribeForGitHubUsers()
  }
  
  private func subscribeForGitHubUsers() {
    dataProvider.conversionRatesPublisher
      .receive(on: DispatchQueue.main)
      .dropFirst()
      .sink { [weak self] conversionRates in
        guard let self else { return }
        isLoading = false
        self.exchangeRates = conversionRates
        self.updateCurrencyAmount(for: .baseCurrency, with: baseCurrencyAmount ?? 0.0)
        self.rowModel = dataProvider.cacheCurrencies.compactMap({ key in
          self.generateRowModel(for: key)
        })
      }
      .store(in: &cancellables)
  }
  
  private func generateRowModel(for country: String) -> CurrencyRowViewModel? {
    guard let rate = exchangeRates[country] else { return nil }
    return CurrencyRowViewModel(baseCurrencyCode: baseCurrencyCode, quoteCurrencyCode: country, quoteCurrencyFlag: country.countryFlag(), quoteCurrencyName: country.currencyName(), amount: (baseCurrencyAmount ?? 0.0) * rate, rate: rate)
  }
  
  func loadConversionRates() {
    isLoading = true
    dataProvider.loadConversionRate(for: baseCurrencyCode)
  }
  
  func didTappedSwapping() {
    let tempBaseCurrencyCode = baseCurrencyCode
    baseCurrencyCode = quoteCurrencyCode
    quoteCurrencyCode = tempBaseCurrencyCode
    baseCurrencyAmount = 1000
    loadConversionRates()
  }
  
  func updateCurrencyAmount(for type: CurrencyType, with amount: Double) {
    guard let value = exchangeRates[quoteCurrencyCode] else { return }
    switch type {
    case .baseCurrency:
      baseCurrencyAmount = amount
      quoteCurrencyAmount = amount * value
    case .quoteCurrncy:
      baseCurrencyAmount = amount / value
      quoteCurrencyAmount = amount
    }
    self.rowModel = dataProvider.cacheCurrencies.compactMap({ key in
      self.generateRowModel(for: key)
    })
  }
  
  func updateCurrencyCode(for type: CurrencyType, with currencyCode: String) {
    switch type {
    case .baseCurrency:
      baseCurrencyCode = currencyCode
      loadConversionRates()
    case .quoteCurrncy:
      quoteCurrencyCode = currencyCode
      updateCurrencyAmount(for: type, with: baseCurrencyAmount ?? 0.0)
    }
  }
  
  func addCurrency(newCurrencyCode: String) {
    guard !rowModel.contains(where: { $0.quoteCurrencyCode == newCurrencyCode }),
          let model = generateRowModel(for: newCurrencyCode) else { return }
    rowModel.append(model)
    dataProvider.addCurrency(newCurrencyCode: newCurrencyCode)
  }
  
  func removeCurrency(currencyCode: String) {
    rowModel.removeAll(where: { $0.quoteCurrencyCode == currencyCode })
    dataProvider.removeCurrency(currencyCode: currencyCode)
  }
}
