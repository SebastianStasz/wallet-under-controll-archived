//
//  ValidationManager.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 14/05/2021.
//

import Foundation

class ValidationManager: ValidationService {
   private let currencyRegex = "\\d+(?:[\\.\\,]\\d{1,2})?"
   
   func validateName(_ text: String, usedNames: [String] = []) -> NameValidation {
      if text.isEmpty { return .isEmpty }
      
      let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
      let usedNames = usedNames.map { $0.lowercased() }
      if usedNames.contains(text.lowercased()) { return .notUnique }
      
      let textWithoutSpaces = text.replacingOccurrences(of: " ", with: "")
      if textWithoutSpaces.count < 3 { return .tooShort }
      if textWithoutSpaces.count >= 15 { return .tooLong }
      
      return .isValid
   }
    
   func validateCurrency(_ text: String, canEqualZero: Bool = true) -> BalanceValidation {
      if text.isEmpty { return .isEmpty }
      
      if !canEqualZero, Double(text.comasToDots()) == 0 { return .isZero }
      
      let currencyPredicate = NSPredicate(format: "SELF MATCHES %@", currencyRegex)
      if currencyPredicate.evaluate(with: text) { return .isValid }
      
      return .isInvalid
   }
}


