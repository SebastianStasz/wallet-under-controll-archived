//
//  ValidationService.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 14/05/2021.
//

import Foundation

protocol ValidationService {
   func validateName(_ text: String, usedNames: [String]) -> NameValidation
   func validateCurrency(_ text: String, canEqualZero: Bool) -> BalanceValidation
}

extension ValidationService {
   func validateCurrency(_ text: String, canEqualZero: Bool = true) -> BalanceValidation {
      validateCurrency(text, canEqualZero: canEqualZero)
   }
}

enum NameValidation {
   case notUnique
   case tooShort
   case tooLong
   case isEmpty
   case isValid
   
   var message: String? {
      switch self {
      case .notUnique:
         return "Name is already taken."
         
      case .tooShort:
         return "Name must have at least 3 characters."
         
      case .tooLong:
         return "Name is too long. Max 15 characters."
         
      case .isEmpty:
         return "Name can not be empty."
         
      case .isValid: return nil
      }
   }
}

enum BalanceValidation: Equatable {
   case isEmpty
   case isZero
   case isInvalid
   case isValid
   
   func message(fieldName: String = "Value") -> String? {
      switch self {
      case .isEmpty:
         return "\(fieldName) can not be empty."
      case .isZero:
         return "\(fieldName) can not equal 0."
      case .isInvalid:
         return "\(fieldName) is invalid."
      case .isValid:
         return nil
      }
   }
}

