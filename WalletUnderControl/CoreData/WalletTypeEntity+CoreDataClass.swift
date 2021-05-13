//
//  WalletTypeEntity+CoreDataClass.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//
//

import Foundation
import CoreData

@objc(WalletTypeEntity)
public class WalletTypeEntity: NSManagedObject {
   static let sortByNameASC = NSSortDescriptor(keyPath: \WalletTypeEntity.name, ascending: true)
}

extension WalletTypeEntity: CoreDataEntity {
   static let name = "WalletTypeEntity"
}

// MARK: -- Methods

extension WalletTypeEntity {
   static let fetchedResultsController = FetchedResultsController<WalletTypeEntity>()
   
   static func create(in context: NSManagedObjectContext, name: String) {
      let walletType = WalletTypeEntity(context: context)
      walletType.name = name
   }
}
