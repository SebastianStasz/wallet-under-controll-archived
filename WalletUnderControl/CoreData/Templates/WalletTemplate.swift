//
//  WalletTemplate.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 10/05/2021.
//

import Foundation

struct WalletTemplate {
   let name: String
   let icon: WalletIcon
   let iconColor: IconColor
   let type: WalletTypeEntity
   let initialBalance: Double
   let currency: CurrencyEntity
}

extension WalletTemplate {
   
   init?(using walletForm: WalletFormVC.Form) {
      guard let type = walletForm.walletType, let balance = walletForm.initialBalance, let currency = walletForm.currency else {
         return nil
      }
      self.init(name: walletForm.name, icon: walletForm.icon, iconColor: walletForm.iconColor, type: type, initialBalance: balance, currency: currency)
   }
   
}
