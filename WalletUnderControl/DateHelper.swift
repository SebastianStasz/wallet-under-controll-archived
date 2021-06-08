//
//  DateHelper.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//

import Foundation

protocol DateFormatterType {
   func string(from date: Date, format: DateFormatter.Style, time: Bool) -> String
}

class DateHelper: DateFormatterType {
   static let shared = DateHelper()
   
   private let cachedDateFormattersQueue = DispatchQueue(label: "com.boles.date.formatter.queue")
   private var cachedDateFormatters: [String : DateFormatter] = [:]

   private func cachedDateFormatter(withFormat format: DateFormatter.Style, time: Bool) -> DateFormatter {
      cachedDateFormattersQueue.sync {
         let key = "\(format.rawValue) \(time ? 100 : 0)"
         
         if let cachedFormat = cachedDateFormatters[key] { return cachedFormat }
         
         let dateFormatter = DateFormatter()
         dateFormatter.locale = .current
         dateFormatter.dateStyle = format
         if time { dateFormatter.timeStyle = .short }
         
         cachedDateFormatters[key] = dateFormatter
         return dateFormatter
      }
   }
   
   private func cachedDateFormatter(withFormat format: String) -> DateFormatter {
      cachedDateFormattersQueue.sync {
         if let cachedFormat = cachedDateFormatters[format] { return cachedFormat }
         
         let dateFormatter = DateFormatter()
         dateFormatter.locale = .current
         dateFormatter.dateFormat = format
         
         cachedDateFormatters[format] = dateFormatter
         return dateFormatter
      }
   }
   
   func string(from date: Date, format: DateFormatter.Style = .medium, time: Bool) -> String {
      cachedDateFormatter(withFormat: format, time: time).string(from: date)
   }
   
   func string(from date: Date, format: String) -> String {
      cachedDateFormatter(withFormat: format).string(from: date)
   }
}
