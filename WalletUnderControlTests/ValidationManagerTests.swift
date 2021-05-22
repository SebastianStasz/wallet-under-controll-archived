//
//  ValidationManagerTests.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 14/05/2021.
//

import XCTest
@testable import WalletUnderControl

class ValidationManagerTests: XCTestCase {
   
   private var validationManager: ValidationManager!
   
   override func setUpWithError() throws {
      self.validationManager = ValidationManager()
   }
   
   // MARK: -- Name Validation
   
   func test_validate_correct_names() throws {
      let names = ["Test", "   Savings", "Some Value  ", "ALA LA1 23---", "Sample.Name"]
      let usedNames = ["Test2", "SomeValue", "Savingss"]
      for name in names {
         let validation = validationManager.validateName(name, usedNames: usedNames)
         XCTAssertEqual(validation, .isValid, "'\(name)' should be valid.")
      }
   }
   
   func test_validate_too_short_names() throws {
      let names = ["a", "aa", " a", " aa  ", "aa   ", "a a ", " a a "]
      for name in names {
         let validation = validationManager.validateName(name, usedNames: [])
         XCTAssertEqual(validation, .tooShort, "'\(name)' should be 'tooShort'.")
      }
   }
   
   func test_validate_too_long_names() throws {
      let names = ["1234567890asdfg", "1234567890asdfg  ", " 1234567890asdfg"]
      for name in names {
         let validation = validationManager.validateName(name, usedNames: [])
         XCTAssertEqual(validation, .tooLong, "'\(name)' should be 'tooLong'.")
      }
   }
   
   func test_validate_not_unique_names() throws {
      let names = ["test", "Test", "  test  "]
      let usedNames = ["test"]
      for name in names {
         let validation = validationManager.validateName(name, usedNames: usedNames)
         XCTAssertEqual(validation, .notUnique, "'Test' should be 'notUnique'.")
      }
   }
   
   func test_validate_empty_names() throws {
      let validation = validationManager.validateName("", usedNames: ["", "Test"])
      XCTAssertEqual(validation, .isEmpty, "Result should be 'isEmpty'.")
   }
   
   // MARK: -- Currency Validation
   
   func test_validate_correct_currencies() throws {
      let values = ["1", "10", "10.0", "10,0", "9,10", "9,95", "5.51", "001.01", "05", "0,1", "0.9", "0", "0,0", "0,00", "0.0", "0.00", "00,0", "00.0", "00,00", "00.00", "000.0"]
      for value in values {
         let validation = validationManager.validateCurrency(value)
         XCTAssertEqual(validation, .isValid, "'\(value)' should be valid.")
         
         let cur = value.replacingOccurrences(of: ",", with: ".")
         XCTAssertNotNil(Double(cur), "'\(cur)' should be possible to transfer to Double.")
      }
   }
   
   func test_validate_incorrect_currencies() throws {
      let values = ["0.000", "0,000", ".", ",", "0..0", "0,,0", "1.,1", "12.0.", "12,1,", "12.", "15,"]
      for value in values {
         let validation = validationManager.validateCurrency(value)
         XCTAssertEqual(validation, .isInvalid, "'\(value)' should be invalid.")
      }
   }
   
   func test_validate_equal_to_zero_values() throws {
      let values = ["0.00", "0,00", "0", "00.00", "00,00", "00,0", "00.0"]
      for value in values {
         let validation = validationManager.validateCurrency(value, canEqualZero: false)
         XCTAssertEqual(validation, .isZero, "'\(value)' should be 'isZero'.")
      }
   }
   
   func test_empty_currency() throws {
      let validation = validationManager.validateCurrency("")
      XCTAssertEqual(validation, .isEmpty, "Result of empty string should be 'isEmpty'.")
   }
}

