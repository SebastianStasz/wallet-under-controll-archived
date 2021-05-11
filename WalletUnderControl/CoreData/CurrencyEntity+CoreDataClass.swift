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
