//
//  CurrencyConversionAppTests.swift
//  CurrencyConversionAppTests
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import XCTest
import Combine
@testable import CurrencyConversionApp

class ExchangeRateViewModelTests: XCTestCase {
    var viewModel: ExchangeRateViewModel!
    var mockDataProvider: MockDataProvider!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockDataProvider = MockDataProvider()
        viewModel = ExchangeRateViewModel(dataProvider: mockDataProvider)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockDataProvider = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialValues() {
        XCTAssertEqual(viewModel.baseCurrencyCode, "USD")
        XCTAssertEqual(viewModel.quoteCurrencyCode, "EUR")
        XCTAssertEqual(viewModel.baseCurrencyAmount, 1000)
        XCTAssertEqual(viewModel.quoteCurrencyAmount, 0.0)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testLoadConversionRates() {
        viewModel.loadConversionRates()
        XCTAssertTrue(viewModel.isLoading)
    }
    
    func testSwappingCurrencies() {
        viewModel.didTappedSwapping()
        XCTAssertEqual(viewModel.baseCurrencyCode, "EUR")
        XCTAssertEqual(viewModel.quoteCurrencyCode, "USD")
        XCTAssertEqual(viewModel.baseCurrencyAmount, 1000)
    }
    
    func testUpdateCurrencyAmount() {
      viewModel.loadConversionRates()
      viewModel.updateCurrencyAmount(for: .baseCurrency, with: 2000)
      XCTAssertEqual(viewModel.baseCurrencyAmount, 2000)
      XCTAssertEqual(viewModel.quoteCurrencyAmount, 2000 * 0.93)
    }
    
    func testAddAndRemoveCurrency() {
      viewModel.loadConversionRates()
      viewModel.addCurrency(newCurrencyCode: "JPY")
      XCTAssertTrue(viewModel.rowModel.contains { $0.quoteCurrencyCode == "JPY" })
      
      viewModel.removeCurrency(currencyCode: "JPY")
      XCTAssertFalse(viewModel.rowModel.contains { $0.quoteCurrencyCode == "JPY" })
    }
}
