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
   
   func string(format: String) -> String {
      DateHelper.shared.string(from: self, format: format)
   }
}

extension Optional where Wrapped == Date {
   func string(format: DateFormatter.Style, withTime time: Bool = false) -> String {
      guard let date = self else { return "None" }
      return date.string(format: format, withTime: time)
   }
   
   func string(format: String) -> String {
      guard let date = self else { return "None" }
      return date.string(format: format)
   }
}

extension Date {
   
   func getComponent(_ type: Calendar.Component) -> Int {
      Calendar.current.component(type, from: self)
   }
}

// MARK: -- Random Date

extension Date {
   
   static func randomBetween(start: Date, end: Date) -> Date {
      var date1 = start
      var date2 = end
      if date2 < date1 {
         let temp = date1
         date1 = date2
         date2 = temp
      }
      let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
      return Date(timeIntervalSinceNow: span)
   }
}
