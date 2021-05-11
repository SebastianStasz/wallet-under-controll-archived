//
//  Settings.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 11/05/2021.
//

import Foundation

protocol SettingsProtocol {
   var primaryCurrencyCode: String { get }
   var secondaryCurrencyCode: String { get }
   
   func setCurrency(_ currency: CurrencyEntity, for key: Settings.Currency) -> Void
}


struct Settings: SettingsProtocol {
   private let userDefaults: UserDefaults
   
   var primaryCurrencyCode: String {
      guard let code = userDefaults.string(forKey: Currency.primary.key) else {
         userDefaults.setValue("PLN", forKey: Currency.primary.key)
         return self.primaryCurrencyCode
      }
      return code
   }
   
   var secondaryCurrencyCode: String {
      guard let code = userDefaults.string(forKey: Currency.secondary.key) else {
         userDefaults.setValue("EUR", forKey: Currency.secondary.key)
         return self.secondaryCurrencyCode
      }
      return code
   }
   
   init(userDefaults: UserDefaults = UserDefaults.standard) {
      self.userDefaults = userDefaults
   }
   
   // MARK: -- Intents
   
   func setCurrency(_ currency: CurrencyEntity, for key: Currency) {
      if key == .primary && secondaryCurrencyCode == currency.code {
         userDefaults.setValue(primaryCurrencyCode, forKey: Currency.secondary.key)
         
      } else if key == .secondary && primaryCurrencyCode == currency.code {
         userDefaults.setValue(secondaryCurrencyCode, forKey: Currency.primary.key)
      }
      
      userDefaults.setValue(currency.code, forKey: key.key)
   }
}

extension Settings {
   enum Currency {
      case primary
      case secondary
      
      var key: String {
         switch self {
         case .primary:
            return UserDefaults.Key.primaryCurrencyCode.rawValue
         case .secondary:
            return UserDefaults.Key.secondaryCurrencyCode.rawValue
         }
      }
   }
}
