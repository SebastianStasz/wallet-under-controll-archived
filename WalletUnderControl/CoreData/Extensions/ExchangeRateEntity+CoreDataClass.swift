//
//  ExchangeRateEntity+CoreDataClass.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//
//

import Foundation
import CoreData

@objc(ExchangeRateEntity)
public class ExchangeRateEntity: NSManagedObject {

}

extension ExchangeRateEntity {
   
   static func create(from baseCurrency: CurrencyEntity, to currencyCode: String, value: Double, in context: NSManagedObjectContext) {
      let exchangeRate = ExchangeRateEntity(context: context)
      exchangeRate.base = baseCurrency
      exchangeRate.code = currencyCode
      exchangeRate.rateValue = value
   }
}
