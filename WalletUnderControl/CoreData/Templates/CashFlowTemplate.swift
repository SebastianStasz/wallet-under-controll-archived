//
//  CashFlowTemplate.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//

import Foundation

struct CashFlowTemplate {
   let name: String
   let date: Date
   let value: Double
   let wallet: WalletEntity
   let category: CashFlowCategoryEntity
}

extension CashFlowTemplate {
   
   init?(name: String?, date: Date, value: String?, wallet: WalletEntity, category: CashFlowCategoryEntity?) {
      guard let name = name, let amount = Double(value ?? "X"), let category = category else { return nil }
      
      self.name = name
      self.date = date
      self.value = amount
      self.wallet = wallet
      self.category = category
   }

}
