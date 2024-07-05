//
//  CurrencyListViewModelTests.swift
//  CurrencyConversionAppTests
//
//  Created by Keyur Bhalodiya on 2024/07/04.
//

import XCTest
@testable import CurrencyConversionApp

final class CurrencyListViewModelTests: XCTestCase {
    var viewModel: CurrencyListViewModel!
    
    override func setUp() {
        super.setUp()
        let currencies = ["USD", "EUR", "GBP", "JPY", "INR"]
        viewModel = CurrencyListViewModel(currencies: currencies)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testInitialValues() {
        XCTAssertEqual(viewModel.filterCurrencies, ["USD", "EUR", "GBP", "JPY", "INR"])
    }
    
    func testDidSearchCurrency() {
        viewModel.didSearchCurrency(with: "U")
        XCTAssertEqual(viewModel.filterCurrencies, ["USD", "EUR"])
        
        viewModel.didSearchCurrency(with: "E")
        XCTAssertEqual(viewModel.filterCurrencies, ["EUR"])
        
        viewModel.didSearchCurrency(with: "J")
        XCTAssertEqual(viewModel.filterCurrencies, ["JPY"])
        
        viewModel.didSearchCurrency(with: "Z")
        XCTAssertEqual(viewModel.filterCurrencies, [])
    }
    
    func testDidCancelSearchCurrency() {
        viewModel.didSearchCurrency(with: "U")
        XCTAssertEqual(viewModel.filterCurrencies, ["USD", "EUR"])
        
        viewModel.didCancelSearchCurrency()
        XCTAssertEqual(viewModel.filterCurrencies, ["USD", "EUR", "GBP", "JPY", "INR"])
    }
}

