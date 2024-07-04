//
//  ContentView.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import SwiftUI

struct ContentView: View {
  
  @State private var isLoading: Bool = false
  
  var body: some View {
    let dataProvider = DataProvider(repo: ExchangeRateRepository())
    let viewModel = ExchangeRateViewModel(dataProvider: dataProvider)
    ExchangeRateView(viewModel: viewModel)
      .environment(\.isLoading, $isLoading)
      .hudOverlay(isLoading)
  }
}

struct LoadingEnvironmentKey: EnvironmentKey {
    public static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var isLoading: Binding<Bool> {
        get {
            self [LoadingEnvironmentKey.self]
        }
        set {
            self [LoadingEnvironmentKey.self] = newValue
        }
    }
}

#Preview {
    ContentView()
}
