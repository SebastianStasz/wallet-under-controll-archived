//
//  CurrencyEntity+CoreDataProperties.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 16/05/2021.
//
//

import Foundation
import CoreData


extension CurrencyEntity {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CurrencyEntity> {
        return NSFetchRequest<CurrencyEntity>(entityName: "CurrencyEntity")
    }

   @NSManaged public var code: String
   @NSManaged public var name: String
   @NSManaged public var updateDate: Date?
   @NSManaged public var wallets: [WalletEntity]
   @NSManaged public var exchangeRates: Set<ExchangeRateEntity>

}

// MARK: Generated accessors for exchangeRates
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

// MARK: Generated accessors for wallets
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

extension CurrencyEntity : Identifiable {
//   public var id: String { code }
}
