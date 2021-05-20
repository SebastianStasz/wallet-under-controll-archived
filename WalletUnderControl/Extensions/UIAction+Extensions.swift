//
//  UIAction+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//

import UIKit

extension UIAction {
   
   static func delete(handler: @escaping () -> Void ) -> UIAction {
      UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { _ in
         handler()
      }
   }
   
   static func edit(handler: @escaping () -> Void) -> UIAction {
      UIAction(title: "Edit", image: UIImage(systemName: "pencil.circle")) { _ in
         handler()
      }
   }
   
   static func addExpense(handler: @escaping () -> Void) -> UIAction {
      UIAction(title: "Add Expense", image: UIImage(systemName: "minus.rectangle")) { _ in
         handler()
      }
   }
   
   static func addIncome(handler: @escaping () -> Void) -> UIAction {
      UIAction(title: "Add Income", image: UIImage(systemName: "plus.rectangle")) { _ in
         handler()
      }
   }
}
