//
//  UIAction+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//

import UIKit

extension UIAction {
   
   static func deleteAction(handler: @escaping () -> Void ) -> UIAction {
      UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { _ in
         handler()
      }
   }
   
   static func editAction(handler: @escaping () -> Void) -> UIAction {
      UIAction(title: "Edit", image: UIImage(systemName: "pencil.circle")) { _ in
         handler()
      }
   }
}
