//
//  CurrencyEntity+CoreDataClass.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//
//

import Foundation
import CoreData

@objc(CurrencyEntity)
public class CurrencyEntity: NSManagedObject {
   static let sortByCodeASC = NSSortDescriptor(keyPath: \CurrencyEntity.code, ascending: true)
}

extension CurrencyEntity {
   
   static func create(code: String, name: String, in context: NSManagedObjectContext) -> CurrencyEntity {
      let currency = CurrencyEntity(context: context)
      currency.code = code
      currency.name = name
      currency.updateDate = nil
      return currency
   }
}
