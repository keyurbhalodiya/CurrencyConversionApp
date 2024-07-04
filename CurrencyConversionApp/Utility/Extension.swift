//
//  Extension.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import Foundation
import SwiftUI

extension String {
  /// Get country flag
  func countryFlag() -> String {
    guard self.count > 2 else { return "" }
    let countryCode = self.prefix(2)
    let base : UInt32 = 127397
    var s = ""
    for v in countryCode.unicodeScalars {
      s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    return String(s)
  }
  
  /// Get currency name
  func currencyName() -> String {
    Locale.current.localizedString(forCurrencyCode: self) ?? self
  }
}

extension View {
  func hudOverlay(_ isShowing: Bool) -> some View {
    modifier(
      LoadingIndicatorModifier(isShowing: isShowing)
    )
  }
}
