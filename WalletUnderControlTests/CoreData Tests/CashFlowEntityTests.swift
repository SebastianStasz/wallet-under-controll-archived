//
//  CashFlowEntityTests.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//

import XCTest
@testable import WalletUnderControl

class CashFlowEntityTests: XCTestCase {
 
   private let context = PersistenceController.empty.context
   
   override func setUpWithError() throws {
      context.reset()
   }
   
   func test_create_cash_flow_entity() throws {
      let template = getSampleCashFlowTemplate(name: "Test", value: 25)
      let cashFlows = fetchCashFlow()
      XCTAssert(cashFlows.isEmpty, "Database should be empty.")
      
      CashFlowEntity.create(in: context, using: template)
      
      let cashFlows2 = fetchCashFlow()
      XCTAssert(cashFlows2.count == 1, "One CashFlow should be created.")
      
      let cashFlow = cashFlows2.first!
      XCTAssertEqual(cashFlow.name, template.name)
      XCTAssertEqual(cashFlow.date, template.date)
      XCTAssertEqual(cashFlow.value, template.value)
      XCTAssertEqual(cashFlow.wallet, template.wallet)
      XCTAssertEqual(cashFlow.category, template.category)
   }
   
   func test_update_cash_flow_entity() throws {
      let template = getSampleCashFlowTemplate(name: "Test", value: 25)
      CashFlowEntity.create(in: context, using: template)
      
      let cashFlow = fetchCashFlow().first!
      
      let updatedCategory = CashFlowCategoryEntity.createCashFlowCategories(context: context).first!
      
      let updatedTemplate = CashFlowTemplate(name: "Updated Name", date: Date(), value: 100, wallet: template.wallet, category: updatedCategory)
      
      cashFlow.update(using: updatedTemplate)
      XCTAssertEqual(cashFlow.name, updatedTemplate.name)
      XCTAssertEqual(cashFlow.date, updatedTemplate.date)
      XCTAssertEqual(cashFlow.value, updatedTemplate.value)
      XCTAssertEqual(cashFlow.category, updatedCategory)
   }
   
   func test_create_cash_flow_entity_with_invalid_name() throws {
      let template = getSampleCashFlowTemplate(name: "  Te st Name  \n   ", value: 25)
      
      CashFlowEntity.create(in: context, using: template)
      let cashFlow = fetchCashFlow().first!
      
      XCTAssertEqual(cashFlow.name, "Te st Name", "Trailing, leading spaces and new lines should be deleted.")
   }
   
   // MARK: Predicate Tests
   
   func test_cash_flow_predicate_date_and_type() throws {
      let wallet = WalletEntity.createWallet(context: context)
      let income = CashFlowCategoryEntity.createCashFlowCategory(type: .income, context: context)
      let expense = CashFlowCategoryEntity.createCashFlowCategory(type: .expense, context: context)
      let date1 = DateComponents(calendar: Calendar.current, year: 2021, month: 3, day: 1).date!
      let date2 = DateComponents(calendar: Calendar.current, year: 2021, month: 3, day: 15).date!
      let date3 = DateComponents(calendar: Calendar.current, year: 2021, month: 3, day: 31, hour: 23, minute: 59, second: 59).date!
      let date4 = DateComponents(calendar: Calendar.current, year: 2021, month: 4, day: 1).date!
      let date5 = DateComponents(calendar: Calendar.current, year: 2021, month: 2, day: 28).date!
      let t1 = CashFlowTemplate(name: "cf1", date: date1, value: 10, wallet: wallet, category: income)
      let t2 = CashFlowTemplate(name: "cf2", date: date2, value: 10, wallet: wallet, category: expense)
      let t3 = CashFlowTemplate(name: "cf3", date: date3, value: 10, wallet: wallet, category: income)
      let t4 = CashFlowTemplate(name: "cf4", date: date4, value: 10, wallet: wallet, category: income)
      let t5 = CashFlowTemplate(name: "cf5", date: date5, value: 10, wallet: wallet, category: expense)
      
      for t in [t1, t2, t3, t4, t5] {
         CashFlowEntity.create(in: context, using: t)
      }
      
      let cashFlows = fetchCashFlow(predicate: CashFlowEntity.filter(type: .income, month: 3, year: 2021))
      XCTAssertEqual(cashFlows.count, 2, "'cf1' and 'cf3' should be fetched.")
      XCTAssertEqual(cashFlows[0].name, "cf1")
      XCTAssertEqual(cashFlows[1].name, "cf3")
   }
}

// MARK: -- Helpers

extension CashFlowEntityTests {
   
   private func fetchCashFlow(predicate: NSPredicate? = nil) -> [CashFlowEntity] {
      let request = CashFlowEntity.createFetchRequest()
      request.sortDescriptors = [CashFlowEntity.sortByDateASC]
      request.predicate = predicate
      
      let cashFlows = try! context.fetch(request)
      return cashFlows
   }
   
   private func getSampleCashFlowTemplate(name: String, value: Double) -> CashFlowTemplate {
      let wallet = WalletEntity.createWallet(context: context)
      let category = CashFlowCategoryEntity.createCashFlowCategory(type: .income, context: context)
      let template = CashFlowTemplate(name: name, date: Date(), value: value, wallet: wallet, category: category)
      
      return template
   }
}
