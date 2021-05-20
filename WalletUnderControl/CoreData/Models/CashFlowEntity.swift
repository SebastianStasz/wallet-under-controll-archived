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
   
   static func filter(type: CashFlowType, month: Int, year: Int) -> NSPredicate {
      let startOfMonth = DateComponents.init(calendar: Calendar.current, year: year, month: month, day: 1)
      let startDate = startOfMonth.date! 
      let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
      
      let type = NSPredicate(format: "category.type_ == \(type.rawValue)")
      let date = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
      return NSCompoundPredicate(andPredicateWithSubpredicates: [type, date])
   }
   
   static func create(in context: NSManagedObjectContext, using template: CashFlowTemplate) {
      let cashFlow = CashFlowEntity(context: context)
      cashFlow.wallet = template.wallet
      cashFlow.category = template.category
      cashFlow.update(using: template)
   }
   
   func update(using template: CashFlowTemplate) {
      assert(template.category.type == self.category.type, "It should NOT be possible to change cash-flow type, e.g. 'expense' to 'income'.")
      
      let isExpense = template.category.type == .expense
      wallet.increaseBalance(by: isExpense ? self.value : template.value )
      wallet.decreaseBalance(by: isExpense ? template.value : self.value)
      
      let name = template.name.trimmingCharacters(in: .whitespacesAndNewlines)
      
      self.name = name
      self.date = template.date
      self.value = template.value
      self.category = template.category
   }
}

extension CashFlowEntity: Identifiable { }
