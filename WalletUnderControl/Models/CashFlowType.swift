//
//  CashFlowType.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//

import Foundation

enum CashFlowType: Int16 {
   case income
   case expense
   
   var name: String {
      switch self {
      case .income: return "Income"
      case .expense: return "Expense"
      }
   }
}
