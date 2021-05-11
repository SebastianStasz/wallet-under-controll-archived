//
//  WalletTypeEntity+CoreDataProperties.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//
//

import Foundation
import CoreData


extension WalletTypeEntity {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<WalletTypeEntity> {
        return NSFetchRequest<WalletTypeEntity>(entityName: "WalletTypeEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var wallets: [WalletEntity]

}

// MARK: Generated accessors for wallets
extension WalletTypeEntity {

    @objc(addWalletsObject:)
    @NSManaged public func addToWallets(_ value: WalletEntity)

    @objc(removeWalletsObject:)
    @NSManaged public func removeFromWallets(_ value: WalletEntity)

    @objc(addWallets:)
    @NSManaged public func addToWallets(_ values: NSSet)

    @objc(removeWallets:)
    @NSManaged public func removeFromWallets(_ values: NSSet)

}

extension WalletTypeEntity : Identifiable {

}
