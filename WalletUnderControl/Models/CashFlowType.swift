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
   
   func name(plural: Bool = false) -> String {
      switch self {
      case .income: return plural ? "Incomes" : "Income"
      case .expense:return plural ? "Expenses" : "Expense"
      }
   }
}
