//
//  CurrencyEntity+CoreDataProperties.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//
//

import Foundation
import CoreData


extension CurrencyEntity {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CurrencyEntity> {
        return NSFetchRequest<CurrencyEntity>(entityName: "CurrencyEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var code: String
    @NSManaged public var updateDate: Date
    @NSManaged public var wallets: WalletEntity

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
