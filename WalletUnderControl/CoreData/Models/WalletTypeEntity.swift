//
//  WalletTypeEntity+CoreDataProperties.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//
//

import Foundation
import CoreData

@objc(WalletTypeEntity)
public class WalletTypeEntity: NSManagedObject {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<WalletTypeEntity> {
        return NSFetchRequest<WalletTypeEntity>(entityName: "WalletTypeEntity")
    }

    @NSManaged private(set) var name: String
    @NSManaged private(set) var wallets: [WalletEntity]
}

// MARK: -- Static Properties

extension WalletTypeEntity: GroupingEntity {
   static let sortByNameASC = NSSortDescriptor(keyPath: \WalletTypeEntity.name, ascending: true)
}

// MARK: -- Methods

extension WalletTypeEntity {

   static func create(in context: NSManagedObjectContext, name: String) {
      let walletType = WalletTypeEntity(context: context)
      walletType.update(name: name)
   }
   
   func update(name: String) {
      let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
      self.name = name
   }
}

// MARK: -- Generated accessors for wallets

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


// MARK: -- Sample Data

extension WalletTypeEntity {
   
   static func createWalletTypes(context: NSManagedObjectContext) -> [WalletTypeEntity] {
      let names = ["Getin Bank", "Card", "Savings"]
      var walletTypes: [WalletTypeEntity] = []
      
      for name in names {
         let walletType = WalletTypeEntity(context: context)
         walletType.name = name
         walletTypes.append(walletType)
      }
      
      return walletTypes
   }
   
   static func createWalletType(context: NSManagedObjectContext) -> WalletTypeEntity {
      let walletType = WalletTypeEntity(context: context)
      walletType.name = "Getin Bank"
   
      return walletType
   }
}
