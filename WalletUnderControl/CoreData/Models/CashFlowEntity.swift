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
