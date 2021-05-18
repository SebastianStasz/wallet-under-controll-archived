//
//  CurrencyEntity+CoreDataProperties.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 16/05/2021.
//
//

import Foundation
import CoreData

@objc(CurrencyEntity)
public class CurrencyEntity: NSManagedObject {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CurrencyEntity> {
        return NSFetchRequest<CurrencyEntity>(entityName: "CurrencyEntity")
    }

   @NSManaged private(set) var code: String
   @NSManaged private(set) var name: String
   @NSManaged private(set) var updateDate: Date?
   @NSManaged private(set) var wallets: [WalletEntity]
   @NSManaged private(set) var exchangeRates: Set<ExchangeRateEntity>
}

// MARK: -- Static Properties

extension CurrencyEntity {
   static let sortByCodeASC = NSSortDescriptor(keyPath: \CurrencyEntity.code, ascending: true)
}

// MARK: -- Methods

extension CurrencyEntity {
   
   static func create(code: String, name: String, in context: NSManagedObjectContext) -> CurrencyEntity {
      let currency = CurrencyEntity(context: context)
      currency.code = code
      currency.name = name
      currency.updateDate = nil
      return currency
   }
   
   func update(date: Date) {
      self.updateDate = date
   }
}

// MARK: -- Generated accessors for exchangeRates

extension CurrencyEntity {

    @objc(addExchangeRatesObject:)
    @NSManaged public func addToExchangeRates(_ value: ExchangeRateEntity)

    @objc(removeExchangeRatesObject:)
    @NSManaged public func removeFromExchangeRates(_ value: ExchangeRateEntity)

    @objc(addExchangeRates:)
    @NSManaged public func addToExchangeRates(_ values: NSSet)

    @objc(removeExchangeRates:)
    @NSManaged public func removeFromExchangeRates(_ values: NSSet)

}

// MARK: -- Generated accessors for wallets

extension CurrencyEntity {

    @objc(addWalletsObject:)
    @NSManaged public func addToWallets(_ value: WalletEntity)

    @objc(removeWalletsObject:)
    @NSManaged public func removeFromWallets(_ value: WalletEntity)

    @objc(addWallets:)
    @NSManaged public func addToWallets(_ values: NSSet)

    @objc(removeWallets:)
    @NSManaged public func removeFromWallets(_ values: NSSet)

}

extension CurrencyEntity: Identifiable {}


// MARK: -- Sample Data

extension CurrencyEntity {
   
   static func createCurrencies(context: NSManagedObjectContext) -> [CurrencyEntity] {
      let url = Bundle.main.url(forResource: "currencyData", withExtension: "json")!
      let data = try! Data(contentsOf: url)
      let currenciesData = try! JSONDecoder().decode([String : String].self, from: data)
      
      let currencies = currenciesData.map { currencyData -> CurrencyEntity in
         let currency = CurrencyEntity(context: context)
         currency.code = currencyData.0
         currency.name = currencyData.1
         currency.updateDate = nil
         
         let otherCurrencies = currenciesData.filter({ $0.0 != currency.code })
         
         for currencyData in otherCurrencies {
            ExchangeRateEntity.create(from: currency, to: currencyData.0, value: 0, in: context)
         }
         
         return currency
      }
      
      return currencies
   }
}
