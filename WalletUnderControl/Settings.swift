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
   var isPrimaryCurrencyPresented: Bool { get }
   
   func setCurrency(_ currency: CurrencyEntity, for key: Settings.Keys) -> Void
   func toggleIsPrimaryCurrencyPresented()
}


struct Settings: SettingsProtocol {
   static let shared = Settings()
   
   private let userDefaults: UserDefaults
   
   init(userDefaults: UserDefaults = UserDefaults.standard) {
      self.userDefaults = userDefaults
   }
   
   var primaryCurrencyCode: String {
      guard let code = userDefaults.string(forKey: Keys.primaryCurrency.key) else {
         userDefaults.setValue("PLN", forKey: Keys.primaryCurrency.key)
         return self.primaryCurrencyCode
      }
      return code
   }
   
   var secondaryCurrencyCode: String {
      guard let code = userDefaults.string(forKey: Keys.secondaryCurrency.key) else {
         userDefaults.setValue("EUR", forKey: Keys.secondaryCurrency.key)
         return self.secondaryCurrencyCode
      }
      return code
   }
   
   var isPrimaryCurrencyPresented: Bool {
      guard let isPresented = userDefaults.string(forKey: Keys.isPrimaryCurrencyPresented.key) else {
         userDefaults.setValue("true", forKey: Keys.isPrimaryCurrencyPresented.key)
         return self.isPrimaryCurrencyPresented
      }
      return isPresented == "true" 
   }
   
   // MARK: -- Intents
   
   func setCurrency(_ currency: CurrencyEntity, for key: Keys) {
      if key == .primaryCurrency && secondaryCurrencyCode == currency.code {
         userDefaults.setValue(primaryCurrencyCode, forKey: Keys.secondaryCurrency.key)
         
      } else if key == .secondaryCurrency && primaryCurrencyCode == currency.code {
         userDefaults.setValue(secondaryCurrencyCode, forKey: Keys.primaryCurrency.key)
      }
      
      userDefaults.setValue(currency.code, forKey: key.key)
   }
   
   func toggleIsPrimaryCurrencyPresented() {
      let value = isPrimaryCurrencyPresented ? "false" : "true"
      userDefaults.setValue(value, forKey: Keys.isPrimaryCurrencyPresented.key)
   }
}

extension Settings {
   enum Keys {
      case primaryCurrency
      case secondaryCurrency
      case isPrimaryCurrencyPresented
      
      var key: String {
         switch self {
         case .primaryCurrency:
            return UserDefaults.Key.primaryCurrencyCode.rawValue
         case .secondaryCurrency:
            return UserDefaults.Key.secondaryCurrencyCode.rawValue
         case .isPrimaryCurrencyPresented:
            return UserDefaults.Key.isPrimaryCurrencyPresented.rawValue
         }
      }
   }
}
