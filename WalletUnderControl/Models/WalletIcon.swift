//
//  WalletIcon.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//

import Foundation

public enum WalletIcon: Int16 {
   case bag
   case bagFill
   case bagCircle
   case bagCircleFill
   case cart
   case cartFill
   case creditcard
   case creditcardFill
   case banknote
   case banknoteFill
   
   public var name: String {
      switch self {
      case .bag:
         return "bag"
      case .bagFill:
         return "bag.fill"
      case .bagCircle:
         return "bag.circle"
      case .bagCircleFill:
         return "bag.circle.fill"
      case .cart:
         return "cart"
      case .cartFill:
         return "cart.fill"
      case .creditcard:
         return "creditcard"
      case .creditcardFill:
         return "creditcard.fill"
      case .banknote:
         return "banknote"
      case .banknoteFill:
         return "banknote.fill"
      }
   }
}
