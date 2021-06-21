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
    
    @objc var yearAndMonth: String {
        date.string(format: "yyyy MMMM")
    }
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
        
        let type = filter(type: type)
        let date = NSPredicate(format: "date >= %@ AND date < %@", startDate as NSDate, endDate as NSDate)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [type, date])
    }
    
    static func filter(type: CashFlowType) -> NSPredicate {
        NSPredicate(format: "category.type_ == \(type.rawValue)")
    }

    static func filter(wallet: WalletEntity) -> NSPredicate {
        NSPredicate(format: "wallet == %@", wallet)
    }
    
    static func filter(wallet: WalletEntity, type: CashFlowType) -> NSPredicate {
        let type = filter(type: type)
        let wallet = filter(wallet: wallet)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [type, wallet])
    }
    
    static func create(in context: NSManagedObjectContext, using template: CashFlowTemplate) {
        let cashFlow = CashFlowEntity(context: context)
        cashFlow.wallet = template.wallet
        cashFlow.category = template.category
        cashFlow.update(using: template)
    }

    func delete() {
        wallet.decreaseBalance(by: value)
        managedObjectContext?.delete(self)
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


// MARK: -- Sample Data

extension CashFlowEntity {
    
    @discardableResult
    static func createCashFlows(in context: NSManagedObjectContext) -> [CashFlowEntity] {
        let wallets = WalletEntity.createWallets(context: context)
        let categories = CashFlowCategoryEntity.createCashFlowCategories(context: context)
        let incomeCategories = categories.filter { $0.type == .income }
        let expenseCategories = categories.filter { $0.type == .expense }
        
        var cashFlows: [CashFlowEntity] = []
        
        let incomeNames = ["Salary May", "Salary June", "BTC Investment", "Tax refund", "Extra Income"]
        let incomeValues: [Double] = [4200, 4100, 5000, 623, 300]
        
        let toDate = Date()
        let fromDate = Calendar.current.date(byAdding: .month, value: -3, to: toDate)!
        
        for i in incomeNames.indices {
            let cashFlow = CashFlowEntity(context: context)
            let template = CashFlowTemplate(name: incomeNames[i], date: Date.randomBetween(start: fromDate, end: toDate), value: incomeValues[i], wallet: wallets.randomElement()!, category: incomeCategories.randomElement()!)
            
            cashFlow.wallet = template.wallet
            cashFlow.category = template.category
            
            cashFlow.update(using: template)
            cashFlows.append(cashFlow)
        }
        
        let expenseNames = ["Groccery", "Dog food", "Car Wash", "Netflix", "Insurance", "Bike parts", "Electricity bill", "Shoes", "Bus", "Water bill"]
        let expenseValues: [Double] = [56, 20, 10, 30, 1200, 581, 392, 190, 2.5, 276]
        
        for i in expenseNames.indices {
            let cashFlow = CashFlowEntity(context: context)
            let template = CashFlowTemplate(name: expenseNames[i], date: Date.randomBetween(start: fromDate, end: toDate), value: expenseValues[i], wallet: wallets.randomElement()!, category: expenseCategories.randomElement()!)
            
            cashFlow.wallet = template.wallet
            cashFlow.category = template.category
            
            cashFlow.update(using: template)
            cashFlows.append(cashFlow)
        }
        
        return cashFlows
    }
}
