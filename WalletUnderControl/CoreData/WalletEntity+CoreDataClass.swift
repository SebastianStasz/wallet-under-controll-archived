//
//  WalletEntity+CoreDataClass.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//
//

import Foundation
import CoreData

@objc(WalletEntity)
public class WalletEntity: NSManagedObject {

   var icon: WalletIcon {
      get { WalletIcon(rawValue: icon_)! }
      set { icon_ = newValue.rawValue }
   }
   
   var iconColor: IconColor {
      get { IconColor(rawValue: iconColor_)! }
      set { iconColor_ = newValue.rawValue }
   }
   
}

extension WalletEntity: CoreDataEntity {
   static let name = "WalletEntity"
}

// MARK: -- Methods

extension WalletEntity {
   
   static let fetchedResultsController = FetchedResultsController<WalletEntity>()
   
   static func create(in context: NSManagedObjectContext, using template: WalletTemplate) {
      let wallet = WalletEntity(context: context)
      wallet.id = UUID()
      wallet.creationDate = Date()
      wallet.name = template.name
      wallet.icon = template.icon
      wallet.iconColor = template.iconColor
      wallet.initialBalance = template.initialBalance
      wallet.type = template.type
      wallet.currency = template.currency
   }
}
