//
//  CashFlowEntity+CoreDataProperties.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//
//

import Foundation
import CoreData

@objc(CashFlowEntity)
public class CashFlowEntity: NSManagedObject {
   
   @nonobjc public class func createFetchRequest() -> NSFetchRequest<CashFlowEntity> {
       return NSFetchRequest<CashFlowEntity>(entityName: "CashFlowEntity")
   }

   @NSManaged private(set) var name: String
   @NSManaged private(set) var date: Date
   @NSManaged private(set) var value: Double
   @NSManaged private(set) var wallet: WalletEntity
   @NSManaged private(set) var category: CashFlowCategoryEntity
}

// MARK: -- Static Properties

extension CashFlowEntity {

   static let sortByDateASC = NSSortDescriptor(keyPath: \CashFlowEntity.date, ascending: true)
   static let sortByDateDESC = NSSortDescriptor(keyPath: \CashFlowEntity.date, ascending: false)

}

// MARK: -- Methods

extension CashFlowEntity {
   
   static func create(in context: NSManagedObjectContext, using template: CashFlowTemplate) {
      let cashFlow = CashFlowEntity(context: context)
      cashFlow.wallet = template.wallet
      cashFlow.category = template.category
      cashFlow.update(name: template.name, date: template.date, value: template.value)
   }
   
   func update(name: String, date: Date, value: Double) {
      let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
      
      self.name = name
      self.date = date
      self.value = value
   }
}

extension CashFlowEntity: Identifiable { }
