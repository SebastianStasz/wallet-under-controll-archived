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

   static func fetchedResultsController(in context: NSManagedObjectContext = SceneDelegate.context) -> FetchedResultsController<WalletEntity> {
      let walletTypes = FetchedResultsController<WalletEntity>(context: context)
      return walletTypes
   }
   
   static func create(in context: NSManagedObjectContext, using template: WalletTemplate) {
      let wallet = WalletEntity(context: context)
      wallet.id = UUID()
      wallet.creationDate = Date()
      wallet.initialBalance = template.initialBalance
      wallet.update(using: template)
   }
   
   func update(using template: WalletTemplate) {
      let name = template.name.trimmingCharacters(in: .whitespacesAndNewlines)
      
      self.name = name
      icon = template.icon
      iconColor = template.iconColor
      type = template.type
      currency = template.currency
   }
}
