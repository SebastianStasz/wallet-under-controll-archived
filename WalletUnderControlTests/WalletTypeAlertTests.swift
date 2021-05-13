//
//  WalletTypeAlertTests.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 12/05/2021.
//

import XCTest
@testable import WalletUnderControl

class WalletTypeAlertTests: XCTestCase {
   
   private let context = PersistenceController.empty.context
   private var textFieldDebounce: XCTestExpectation!
   private var walletTypeAlert: WalletTypeAlert!
   
   override func setUpWithError() throws {
      textFieldDebounce = XCTestExpectation(description: "Debounce for text field.")
      walletTypeAlert = nil
      context.reset()
   }
   
   func test_present_alert_without_editing() throws {
      walletTypeAlert = WalletTypeAlert(editing: nil, context: context, usedNames: [])
      
      XCTAssertEqual(alertTitle, "Create Wallet Type", "Default title for alert without editing.")
      XCTAssertEqual(cancelBTN.title, "Cancel", "'Cancel' should be title for cancel button.")
      XCTAssertEqual(actionBTN.title, "Add", "'Add' should be title for action button.")
      XCTAssertEqual(nameTextFieldText, "", "Name text field should be empty.")
      
      XCTAssertEqual(alertMessage, nil, "Message should be nil.")
      XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
      XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
   }
   
   func test_present_alert_with_editing() throws {
      let walletType = CoreDataSample.createWalletType(context: context)
      let walletTypeName = walletType.name
      walletTypeAlert = WalletTypeAlert(editing: walletType, context: context, usedNames: [])
      
      XCTAssertEqual(alertTitle, "Edit \"\(walletTypeName)\"", "Title for alert with editing.")
      XCTAssertEqual(cancelBTN.title, "Cancel", "'Cancel' should be title for cancel button.")
      XCTAssertEqual(actionBTN.title, "Update", "'Update' should be title for action button.")
      XCTAssertEqual(nameTextFieldText, walletTypeName, "Name text field should contain the wallet type name.")
      
      XCTAssertEqual(alertMessage, nil, "Message should be nil.")
      XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
      XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
   }
   
   func test_valid_values() throws {
      let values = ["Test", "   Savings", "Some Value  ", "ALA LA1 23---"]
      let usedNames = ["Test2", "TesT", "SomeValue", "Savingss"]
      for value in values {
         try test_enter_valid_text(for: value, usedNames: usedNames)
         textFieldDebounce = XCTestExpectation(description: "Debounce for text field.")
      }
   }
   
   func test_too_short_values() throws {
      let values = ["a", "aa", " a", " aa  ", "aa   ", "a a ", " a a "]
      for value in values {
         try test_enter_too_short_text(for: value)
         textFieldDebounce = XCTestExpectation(description: "Debounce for text field.")
      }
   }
   
   func test_too_long_values() throws {
      let values = ["1234567890asdfg", "1234567890asdfg  ", " 1234567890asdfg"]
      for value in values {
         try test_enter_too_long_text(for: value)
         textFieldDebounce = XCTestExpectation(description: "Debounce for text field.")
      }
   }
   
   func test_enter_empty_text() throws {
      walletTypeAlert = WalletTypeAlert(editing: nil, context: context, usedNames: [])
      enterToTextField("Test")
      enterToTextField("")
      
      XCTAssertTrue(nameTextFieldText.isEmpty, "Name text field should be empty.")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
         XCTAssertEqual(alertMessage, WalletTypeAlert.NameValidation.isEmpty.message)
         XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
         XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
         textFieldDebounce.fulfill()
      }
      
      wait(for: [textFieldDebounce], timeout: 2)
   }
   
   func test_enter_not_unique_text() throws {
      walletTypeAlert = WalletTypeAlert(editing: nil, context: context, usedNames: ["Test Name"])
      enterToTextField("Test Name")
      
      XCTAssertEqual(nameTextFieldText, "Test Name", "Name text field should containt text 'Test Name'.")
   
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
         XCTAssertEqual(alertMessage, WalletTypeAlert.NameValidation.notUnique.message)
         XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
         XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
         textFieldDebounce.fulfill()
      }
      
      wait(for: [textFieldDebounce], timeout: 2)
   }
   
   // MARK: -- Helper Functions
   
   func test_enter_valid_text(for text: String, usedNames: [String]) throws {
      walletTypeAlert = WalletTypeAlert(editing: nil, context: context, usedNames: usedNames)
      enterToTextField(text)
      
      XCTAssertEqual(nameTextFieldText, text, "Name text field should containt text '\(text)'.")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
         XCTAssertEqual(alertMessage, nil, "Message should be nil.")
         XCTAssertTrue(actionBTN.isEnabled, "Add action should be enabled.")
         XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
         textFieldDebounce.fulfill()
      }
      
      wait(for: [textFieldDebounce], timeout: 2)
   }
   
   func test_enter_too_short_text(for text: String) throws {
      walletTypeAlert = WalletTypeAlert(editing: nil, context: context, usedNames: [])
      enterToTextField(text)
      
      XCTAssertEqual(nameTextFieldText, text, "Name text field should containt text '\(text)'.")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
         XCTAssertEqual(alertMessage, WalletTypeAlert.NameValidation.tooShort.message, "Name '\(text)' is too short.")
         XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
         XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
         textFieldDebounce.fulfill()
      }
      
      wait(for: [textFieldDebounce], timeout: 2)
   }
   
   func test_enter_too_long_text(for text: String) throws {
      walletTypeAlert = WalletTypeAlert(editing: nil, context: context, usedNames: [])
      enterToTextField(text)
      
      XCTAssertEqual(nameTextFieldText, text, "Name text field should containt text '\(text)'.")
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [unowned self] in
         XCTAssertEqual(alertMessage, WalletTypeAlert.NameValidation.tooLong.message)
         XCTAssertFalse(actionBTN.isEnabled, "Add action should be disabled.")
         XCTAssertTrue(cancelBTN.isEnabled, "Cancel action should be enabled.")
         textFieldDebounce.fulfill()
      }
      
      wait(for: [textFieldDebounce], timeout: 2)
   }
}

// MARK: -- Alert Components

extension WalletTypeAlertTests {
   
   private var ac: UIAlertController {
      walletTypeAlert.alertController
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

extension WalletTypeAlertTests {
   func enterToTextField(_ text: String) {
      walletTypeAlert.alertController.textFields![0].text = ""
      walletTypeAlert.alertController.textFields![0].insertText(text)
   }
}
