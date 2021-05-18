//
//  CashFlowCategoryEntityTests.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 18/05/2021.
//

import XCTest
@testable import WalletUnderControl

class CashFlowCategoryEntityTests: XCTestCase {
 
   private let context = PersistenceController.empty.context
   
   override func setUpWithError() throws {
      context.reset()
   }
   
   func test_create_cash_flow_category_entity() throws {
      let cashFlowCategories = fetchCashFlowCategory()
      XCTAssert(cashFlowCategories.isEmpty, "Database should be empty.")
      
      CashFlowCategoryEntity.create(in: context, name: "Test", type: .expense)
      
      let cashFlowsCategories2 = fetchCashFlowCategory()
      XCTAssert(cashFlowsCategories2.count == 1, "One CashFlowCategory should be created.")
      
      let category = cashFlowsCategories2.first!
      XCTAssertEqual(category.name, "Test")
      XCTAssertEqual(category.type, .expense)
      XCTAssertEqual(category.cashFlows, [])
   }
   
   func test_update_cash_flow_category_entity() throws {
      CashFlowCategoryEntity.create(in: context, name: "Test", type: .income)
      let category = fetchCashFlowCategory().first!

      category.update(name: "Updated Name")
      XCTAssertEqual(category.name, "Updated Name")
      XCTAssertEqual(category.type, .income)
      XCTAssertEqual(category.cashFlows, [])
   }
   
   func test_create_cash_flow_category_entity_with_invalid_name() throws {
      CashFlowCategoryEntity.create(in: context, name: "    T e st   \n   ", type: .expense)
      let category = fetchCashFlowCategory().first!
      XCTAssertEqual(category.name, "T e st", "Trailing, leading spaces and new lines should be deleted.")
   }
   
   // MARK: Predicate Tests
   
   func test_cash_flow_predicate_income() throws {
      CashFlowCategoryEntity.create(in: context, name: "Test1", type: .expense)
      CashFlowCategoryEntity.create(in: context, name: "Test2", type: .expense)
      CashFlowCategoryEntity.create(in: context, name: "Test3", type: .income)
      
      let categories = fetchCashFlowCategory(predicate: CashFlowCategoryEntity.filterIncome)
      XCTAssertEqual(categories.count, 1, "Only income should be fetched.")
      XCTAssertEqual(categories.first!.type, .income)
   }
   
   func test_cash_flow_predicate_expense() throws {
      CashFlowCategoryEntity.create(in: context, name: "Test1", type: .expense)
      CashFlowCategoryEntity.create(in: context, name: "Test2", type: .income)
      CashFlowCategoryEntity.create(in: context, name: "Test3", type: .income)
      
      let categories = fetchCashFlowCategory(predicate: CashFlowCategoryEntity.filterExpense)
      XCTAssertEqual(categories.count, 1, "Only expense should be fetched.")
      XCTAssertEqual(categories.first!.type, .expense)
   }
}

// MARK: -- Helpers

extension CashFlowCategoryEntityTests {
 
   private func fetchCashFlowCategory(predicate: NSPredicate? = nil) -> [CashFlowCategoryEntity] {
      let request = CashFlowCategoryEntity.createFetchRequest()
      request.predicate = predicate
      
      let cashFlowCategories = try! context.fetch(request)
      return cashFlowCategories
   }
}
