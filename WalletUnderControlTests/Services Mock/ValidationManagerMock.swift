//
//  ValidationManagerMock.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 15/05/2021.
//

import Foundation
@testable import WalletUnderControl

class ValidationManagerMock: ValidationService {
   
   var nameValidationResult: NameValidation
   var currencyValidationResult: BalanceValidation
   
   init(nameValidationResult: NameValidation, currencyValidationResult: BalanceValidation) {
      self.nameValidationResult = nameValidationResult
      self.currencyValidationResult = currencyValidationResult
   }
   
   func validateName(_ text: String, usedNames: [String]) -> NameValidation {
      nameValidationResult
   }
   
   func validateCurrency(_ text: String) -> BalanceValidation {
      currencyValidationResult
   }
}

// MARK: -- Initializers

extension ValidationManagerMock {
   
   /// Specify result of name validation.
   convenience init(nameValidationResult: NameValidation) {
      self.init(nameValidationResult: nameValidationResult, currencyValidationResult: .isInvalid)
   }
   
   /// Specify result of currency validation.
   convenience init(currencyValidationResult: BalanceValidation) {
      self.init(nameValidationResult: .isEmpty, currencyValidationResult: currencyValidationResult)
   }
}
