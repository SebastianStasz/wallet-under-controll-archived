//
//  Date+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//

import Foundation

// MARK: -- Date Helper

extension Date {
   func string(format: DateFormatter.Style, withTime time: Bool = false) -> String {
      DateHelper.shared.string(from: self, format: format, time: time)
   }
}

extension Optional where Wrapped == Date {
   func string(format: DateFormatter.Style, withTime time: Bool = false) -> String {
      guard let date = self else { return "None" }
      return date.string(format: format, withTime: time)
   }
}
