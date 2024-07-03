//
//  CurrencyListView.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/03.
//

import SwiftUI

public protocol CurrencySelectionViewState: ObservableObject {
  var filterCurrencies: [String] { get set }
}

protocol CurrencyListViewListener {
  func didSearchCurrency(with searchText: String)
  func didCancelSearchCurrency()
}

typealias CurrencySelectionViewModel = CurrencySelectionViewState & CurrencyListViewListener


struct CurrencyListView<ViewModel: CurrencySelectionViewModel>: View {
  
  @StateObject private var viewModel: ViewModel
  let tapHandler: ((String) -> Void)
  
  @State private var searchText = ""
  
  init(viewModel: ViewModel, tapHandler: @escaping ((String) -> Void)) {
    self._viewModel = StateObject(wrappedValue: viewModel)
    self.tapHandler = tapHandler
  }
  
  var body: some View {
    NavigationView {
      List(viewModel.filterCurrencies, id: \.self) { currency in
        HStack {
          Text(currency.countryFlag())
          Text(currency)
          Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
          tapHandler(currency)
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
      .listStyle(.plain)
      .onChange(of: searchText) { newValue in
        guard newValue.count > 0 else {
          viewModel.didCancelSearchCurrency()
          return
        }
        viewModel.didSearchCurrency(with: newValue)
      }
    }
  }
}

#if DEBUG

final class CCurrencyListViewModelMock: CurrencySelectionViewModel {
  var filterCurrencies: [String] = ["SGD", "USD", "JPY", "INR"]
  
  func didSearchCurrency(with searchText: String) { }
  
  func didCancelSearchCurrency() { }
}

#Preview {
  NavigationView {
    CurrencyListView(viewModel: CCurrencyListViewModelMock(), tapHandler: { _ in })
  }
}
#endif
