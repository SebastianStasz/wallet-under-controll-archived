//
//  CashFlowCategoryEntity+CoreDataProperties.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//
//

import Foundation
import CoreData

@objc(CashFlowCategoryEntity)
public class CashFlowCategoryEntity: NSManagedObject {

   @nonobjc public class func createFetchRequest() -> NSFetchRequest<CashFlowCategoryEntity> {
      return NSFetchRequest<CashFlowCategoryEntity>(entityName: "CashFlowCategoryEntity")
   }
   
   @NSManaged private var type_: Int16
   @NSManaged private(set) var name: String
   @NSManaged private(set) var cashFlows: [CashFlowEntity]
   
   private(set) var type: CashFlowType {
      get { CashFlowType(rawValue: type_)! }
      set { type_ = newValue.rawValue }
   }
}

// MARK: -- Static Properties

extension CashFlowCategoryEntity {
   
   static let sortByNameASC = NSSortDescriptor(keyPath: \CashFlowCategoryEntity.name, ascending: true)
   
   static let predicateIncome = NSPredicate(format: "type_ == \(CashFlowType.income.rawValue)")
   static let predicateExpense = NSPredicate(format: "type_ == \(CashFlowType.expense.rawValue)")
}

// MARK: -- Methods

extension CashFlowCategoryEntity {
   
   static func create(in context: NSManagedObjectContext, name: String, type: CashFlowType) {
      let category = CashFlowCategoryEntity(context: context)
      category.type = type
      category.update(name: name)
   }
   
   func update(name: String) {
      let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
      self.name = name
   }
}

// MARK: -- Generated accessors for cashFlows

extension CashFlowCategoryEntity {
   
   @objc(addCashFlowsObject:)
   @NSManaged public func addToCashFlows(_ value: CashFlowEntity)
   
   @objc(removeCashFlowsObject:)
   @NSManaged public func removeFromCashFlows(_ value: CashFlowEntity)
   
   @objc(addCashFlows:)
   @NSManaged public func addToCashFlows(_ values: NSSet)
   
   @objc(removeCashFlows:)
   @NSManaged public func removeFromCashFlows(_ values: NSSet)
   
}

extension CashFlowCategoryEntity: Identifiable { }


// MARK: -- Sample Data

extension CashFlowCategoryEntity {
   
   static func createCashFlowIncomeCategory(context: NSManagedObjectContext) -> CashFlowCategoryEntity {
      let category = CashFlowCategoryEntity(context: context)
      category.name = "Income"
      category.type = .income
      return category
   }
}
