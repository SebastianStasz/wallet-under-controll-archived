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
      let updatedName = "Updated Name"
      let updatedDate = Date()
      let updatedValue = 100.0
      
      cashFlow.update(name: updatedName, date: updatedDate, value: updatedValue)
      XCTAssertEqual(cashFlow.name, updatedName)
      XCTAssertEqual(cashFlow.date, updatedDate)
      XCTAssertEqual(cashFlow.value, updatedValue)
   }
   
   func test_create_cash_flow_entity_with_invalid_name() throws {
      let template = getSampleCashFlowTemplate(name: "  Te st Name  \n   ", value: 25)
      
      CashFlowEntity.create(in: context, using: template)
      let cashFlow = fetchCashFlow().first!
      
      XCTAssertEqual(cashFlow.name, "Te st Name", "Trailing, leading spaces and new lines should be deleted.")
   }
}

// MARK: -- Helpers

extension CashFlowEntityTests {
   
   private func fetchCashFlow() -> [CashFlowEntity] {
      let request = CashFlowEntity.createFetchRequest()
      let cashFlows = try! context.fetch(request)
      return cashFlows
   }
   
   private func getSampleCashFlowTemplate(name: String, value: Double) -> CashFlowTemplate {
      let wallet = WalletEntity.createWallet(context: context)
      let category = CashFlowCategoryEntity.createCashFlowIncomeCategory(context: context)
      let template = CashFlowTemplate(name: name, date: Date(), value: value, wallet: wallet, category: category)
      
      return template
   }
}
