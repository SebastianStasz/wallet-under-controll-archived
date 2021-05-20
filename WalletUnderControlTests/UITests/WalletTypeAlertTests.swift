//
//  GroupingEntityAlertTests.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 12/05/2021.
//

import XCTest
import CoreData
@testable import WalletUnderControl

class GroupingEntityAlertTests: XCTestCase {
   
   private var textFieldDebounce: XCTestExpectation!
   
   private let context = PersistenceController.empty.context
   private var validationManager: ValidationManagerMock!
   private var groupingEntityAlert: GroupingEntityAlert<WalletTypeEntity>!
   
   override func setUpWithError() throws {
      textFieldDebounce = XCTestExpectation(description: "Debounce for text field.")
      validationManager = nil
      groupingEntityAlert = nil
      context.reset()
   }
   
   func test_presenting_alert_for_wallet_type() throws {
      groupingEntityAlert = GroupingEntityAlert<WalletTypeEntity>(editing: nil, context: context, usedNames: [])
      XCTAssertEqual(alertTitle, "Create Wallet Type", "Default title for alert without editing.")
   }
   
   func test_presenting_alert_for_expense_category() throws {
      let expenseCategoryAlert = GroupingEntityAlert<CashFlowCategoryEntity>(cashFlowType: .expense, usedNames: [])
      XCTAssertEqual(expenseCategoryAlert.alertController.title, "Create Expense Category", "Default title for alert without editing.")
   }
   
   func test_presenting_alert_for_income_category() throws {
      let expenseCategoryAlert = GroupingEntityAlert<CashFlowCategoryEntity>(cashFlowType: .income, usedNames: [])
      XCTAssertEqual(expenseCategoryAlert.alertController.title, "Create Income Category", "Default title for alert without editing.")
   }
   
   func test_present_alert_without_editing() throws {
      groupingEntityAlert = GroupingEntityAlert<WalletTypeEntity>(editing: nil, context: context, usedNames: [])
      
      XCTAssertEqual(cancelBTN.title, "Cancel", "'Cancel' should be title for cancel button.")
      XCTAssertEqual(actionBTN.title, "Add", "'Add' should be title for action button.")
      XCTAssertEqual(nameTextFieldText, "", "Name text field should be empty.")
      
      XCTAssertEqual(alertMessage, nil, "Message should be nil.")
      XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
      XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
   }
   
   func test_present_alert_with_editing() throws {
      let walletType = WalletTypeEntity.createWalletType(context: context)
      let walletTypeName = walletType.name
      groupingEntityAlert = GroupingEntityAlert(editing: walletType, context: context, usedNames: [])
      
      XCTAssertEqual(alertTitle, "Edit \"\(walletTypeName)\"", "Title for alert with editing.")
      XCTAssertEqual(cancelBTN.title, "Cancel", "'Cancel' should be title for cancel button.")
      XCTAssertEqual(actionBTN.title, "Update", "'Update' should be title for action button.")
      XCTAssertEqual(nameTextFieldText, walletTypeName, "Name text field should contain the wallet type name.")
      
      XCTAssertEqual(alertMessage, nil, "Message should be nil.")
      XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
      XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
   }
   
   func test_enter_value_to_text_field() throws {
      groupingEntityAlert = GroupingEntityAlert(editing: nil, context: context, usedNames: [])
      enterToTextField("Sample Name")
      XCTAssertEqual(nameTextFieldText, "Sample Name", "Text field should contain text: 'Sample Name'.")
   }
   
   func test_enter_valid_text() throws {
      validationManager = ValidationManagerMock(nameValidationResult: .isValid)
      groupingEntityAlert = GroupingEntityAlert(editing: nil, validationManager: validationManager, context: context, usedNames: [])
      enterToTextField("User entered value")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
         XCTAssertEqual(alertMessage, nil, "Message should be nil.")
         XCTAssertTrue(actionBTN.isEnabled, "Add action should be enabled.")
         XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
         textFieldDebounce.fulfill()
      }
      
      wait(for: [textFieldDebounce], timeout: 2)
   }
   
   func test_enter_too_short_text() throws {
      validationManager = ValidationManagerMock(nameValidationResult: .tooShort)
      groupingEntityAlert = GroupingEntityAlert(editing: nil, validationManager: validationManager, context: context, usedNames: [])
      enterToTextField("User entered value")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
         XCTAssertEqual(alertMessage, NameValidation.tooShort.message)
         XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
         XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
         textFieldDebounce.fulfill()
      }
      
      wait(for: [textFieldDebounce], timeout: 2)
   }
   
   func test_enter_too_long_text() throws {
      validationManager = ValidationManagerMock(nameValidationResult: .tooLong)
      groupingEntityAlert = GroupingEntityAlert(editing: nil, validationManager: validationManager, context: context, usedNames: [])
      enterToTextField("User entered value")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
         XCTAssertEqual(alertMessage, NameValidation.tooLong.message)
         XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
         XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
         textFieldDebounce.fulfill()
      }
      
      wait(for: [textFieldDebounce], timeout: 2)
   }
   
   func test_enter_empty_text() throws {
      validationManager = ValidationManagerMock(nameValidationResult: .isEmpty)
      groupingEntityAlert = GroupingEntityAlert(editing: nil, validationManager: validationManager, context: context, usedNames: [])
      enterToTextField("User entered value")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
         XCTAssertEqual(alertMessage, NameValidation.isEmpty.message)
         XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
         XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
         textFieldDebounce.fulfill()
      }
      
      wait(for: [textFieldDebounce], timeout: 2)
   }
   
   func test_enter_not_unique_text() throws {
      validationManager = ValidationManagerMock(nameValidationResult: .notUnique)
      groupingEntityAlert = GroupingEntityAlert(editing: nil, validationManager: validationManager, context: context, usedNames: [])
      enterToTextField("User entered value")
   
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
         XCTAssertEqual(alertMessage, NameValidation.notUnique.message)
         XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
         XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
         textFieldDebounce.fulfill()
      }
      
      wait(for: [textFieldDebounce], timeout: 2)
   }
}

// MARK: -- Alert Components

extension GroupingEntityAlertTests {
   
   private var ac: UIAlertController {
      groupingEntityAlert.alertController
   }
   
   private var alertTitle: String {
      ac.title!
   }
   
   private var alertMessage: String? {
      ac.message
   }
   
   private var nameTextFieldText: String {
      ac.textFields![0].text!
   }
   
   private var cancelBTN: UIAlertAction {
      ac.actions[1]
   }
   
   private var actionBTN: UIAlertAction {
      ac.actions[0]
   }
}

// MARK: -- Alert Interactions

extension GroupingEntityAlertTests {
   func enterToTextField(_ text: String) {
      groupingEntityAlert.alertController.textFields![0].text = ""
      groupingEntityAlert.alertController.textFields![0].insertText(text)
   }
}
