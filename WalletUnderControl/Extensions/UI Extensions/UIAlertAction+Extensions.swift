//
//  UIAlertAction+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//

import UIKit

extension UIAlertAction {
   
   static var cancel: UIAlertAction {
      UIAlertAction(title: "Cancel", style: .cancel)
   }
   static var okAction: UIAlertAction {
      UIAlertAction(title: "OK", style: .cancel)
   }
   
   static func deleteAction(handler: @escaping () -> Void ) -> UIAlertAction {
      UIAlertAction(title: "Delete", style: .destructive) { _ in handler() }
   }
}
