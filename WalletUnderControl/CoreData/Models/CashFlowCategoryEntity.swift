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

extension CashFlowCategoryEntity {
   
   static let sortByNameASC = NSSortDescriptor(keyPath: \CashFlowCategoryEntity.name, ascending: true)
   
   static func filterByType(_ type: CashFlowType) -> NSPredicate {
      NSPredicate(format: "type_ == \(type.rawValue)")
   }
   
   static func create(in context: NSManagedObjectContext, name: String, type: CashFlowType) {
      let category = CashFlowCategoryEntity(context: context)
      category.type = type
      category.update(name: name)
   }
   
   func update(name: String) {
      let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
      self.name = name
   }
   
   func canBeDeleted() -> Bool {
      self.cashFlows.isEmpty
   }
}

extension CashFlowCategoryEntity: Identifiable {}
extension CashFlowCategoryEntity: GroupingEntity{}

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


// MARK: -- Sample Data

extension CashFlowCategoryEntity {
   
   static func createCashFlowCategory(type: CashFlowType, context: NSManagedObjectContext) -> CashFlowCategoryEntity {
      let category = CashFlowCategoryEntity(context: context)
      category.name = "Cash Flow"
      category.type = type
      return category
   }
   
   static func createCashFlowCategories(context: NSManagedObjectContext) -> [CashFlowCategoryEntity] {
      let incomeNames = ["Work", "Gift", "Bonus", "Crypto"]
      let expenseNames = ["Food", "Car", "Hygiene", "Hobby"]
      
      var categories: [CashFlowCategoryEntity] = []
      
      for name in incomeNames {
         let income = CashFlowCategoryEntity(context: context)
         income.name = name
         income.type = .income
         categories.append(income)
      }
      
      for name in expenseNames {
         let income = CashFlowCategoryEntity(context: context)
         income.name = name
         income.type = .expense
         categories.append(income)
      }
      
      return categories
   }
}
