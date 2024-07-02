//
//  Extension.swift
//  CurrencyConversionApp
//
//  Created by Keyur Bhalodiya on 2024/07/02.
//

import Foundation

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
