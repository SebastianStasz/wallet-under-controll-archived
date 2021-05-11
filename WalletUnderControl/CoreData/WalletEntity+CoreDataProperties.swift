//
//  WalletEntity+CoreDataProperties.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//
//

import Foundation
import CoreData

extension WalletEntity {
   
   @nonobjc public class func createFetchRequest() -> NSFetchRequest<WalletEntity> {
      return NSFetchRequest<WalletEntity>(entityName: "WalletEntity")
   }
   
   @NSManaged public var id: UUID
   @NSManaged public var name: String
   @NSManaged public var icon_: Int16
   @NSManaged public var iconColor_: Int16
   @NSManaged public var creationDate: Date
   @NSManaged public var initialBalance: Double
   @NSManaged public var type: WalletTypeEntity
   @NSManaged public var currency: CurrencyEntity
}

extension WalletEntity : Identifiable {
   
}
