//
//  ExchangeRateEntity+CoreDataProperties.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//
//

import Foundation
import CoreData

@objc(ExchangeRateEntity)
public class ExchangeRateEntity: NSManagedObject {
   
    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ExchangeRateEntity> {
        return NSFetchRequest<ExchangeRateEntity>(entityName: "ExchangeRateEntity")
    }

    @NSManaged private(set) var code: String
    @NSManaged private(set) var rateValue: Double
    @NSManaged private(set) var base: CurrencyEntity
}

// MARK: -- Methods

extension ExchangeRateEntity {
   
   static func create(from baseCurrency: CurrencyEntity, to currencyCode: String, value: Double, in context: NSManagedObjectContext) {
      let exchangeRate = ExchangeRateEntity(context: context)
      exchangeRate.base = baseCurrency
      exchangeRate.code = currencyCode
      exchangeRate.rateValue = value
   }
   
   func update(rateValue: Double) {
      self.rateValue = rateValue
   }
}


extension ExchangeRateEntity: Identifiable {}
