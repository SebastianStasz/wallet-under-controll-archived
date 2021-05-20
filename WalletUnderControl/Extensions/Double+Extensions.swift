//
//  Double+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 20/05/2021.
//

import Foundation

extension Double {
   
   private static let currencyFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      return formatter
   }()
   
   func toCurrency(_ code: String) -> String {
      let formatter = Double.currencyFormatter
      formatter.currencyCode = code
      // TODO: Temporary Force Unwrap
      return formatter.string(for: self)!
   }

}
