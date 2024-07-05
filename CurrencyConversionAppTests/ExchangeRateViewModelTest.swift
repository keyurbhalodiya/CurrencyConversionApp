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
  
  func testUpdateupdateCurrencyCode() {
    viewModel.updateCurrencyCode(for: .baseCurrency, with: "INR")
    XCTAssertEqual(viewModel.baseCurrencyCode, "INR")
    viewModel.updateCurrencyCode(for: .quoteCurrncy, with: "GBP")
    XCTAssertEqual(viewModel.quoteCurrencyCode, "GBP")
  }
  
  
  func testUpdateCurrencyAmount() {
    viewModel.loadConversionRates()
    
    // create expectation
    let expectation = expectation(description: "Mock data loaded")
    var cancellable: AnyCancellable?
    cancellable = viewModel.$rowModel.sink { rowModel in
      guard rowModel.count > 0 else { return }
      
      // mark expectation as fullfilled
      expectation.fulfill()
      cancellable?.cancel()
    }
    
    // wait all created expectation to be fullfilled
    waitForExpectations(timeout: 1)
    
    viewModel.updateCurrencyAmount(for: .baseCurrency, with: 2000)
    XCTAssertEqual(viewModel.baseCurrencyAmount, 2000)
    XCTAssertEqual(viewModel.quoteCurrencyAmount, 2000 * 0.93)
  }
  
  func testAddAndRemoveCurrency() {
    viewModel.loadConversionRates()
    
    // create expectation
    let expectation = expectation(description: "JPY")
    var cancellable: AnyCancellable?
    cancellable = viewModel.$rowModel.sink { rowModel in
      guard rowModel.contains(where: { $0.quoteCurrencyCode == "JPY" }) else { return }
      
      // mark expectation as fullfilled
      expectation.fulfill()
      cancellable?.cancel()
    }
    
    
    // wait all created expectation to be fullfilled
    waitForExpectations(timeout: 1)
    viewModel.addCurrency(newCurrencyCode: "INR")
    XCTAssertTrue(viewModel.rowModel.contains { $0.quoteCurrencyCode == "INR" })
    
    viewModel.removeCurrency(currencyCode: "JPY")
    XCTAssertFalse(viewModel.rowModel.contains { $0.quoteCurrencyCode == "JPY" })
  }
  
  func testQuoteCurrencyRateAndRowModelProperties() {
    viewModel.loadConversionRates()
    
    // create expectation
    let expectation = expectation(description: "Mock data loaded")
    var cancellable: AnyCancellable?
    cancellable = viewModel.$rowModel.sink { rowModel in
      guard rowModel.count > 0 else { return }
      
      // mark expectation as fullfilled
      expectation.fulfill()
      cancellable?.cancel()
    }
    
    // wait all created expectation to be fullfilled
    waitForExpectations(timeout: 1)
    
    XCTAssertEqual(viewModel.quoteCurrencyRate, "1 USD = 0.93 EUR")
    
    let model = viewModel.rowModel.first
    XCTAssertEqual(model?.quoteCurrencyCode, "INR")
    XCTAssertEqual(model?.amount, 83520.0)
    XCTAssertEqual(model?.baseCurrencyCode, "USD")
    XCTAssertEqual(model?.quoteCurrencyFlag, "🇮🇳")
    XCTAssertEqual(model?.quoteCurrencyName, "Indian Rupee")
    XCTAssertEqual(model?.rate, 83.52)
  }
}
