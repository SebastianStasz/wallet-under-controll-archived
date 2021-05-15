//
//  UITextField+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 12/05/2021.
//

import Combine
import UIKit

// MARK: -- Combine Publisher for UITextField

extension UITextField {
   func textPublisher() -> AnyPublisher<String, Never> {
      NotificationCenter.default
         .publisher(for: UITextField.textDidChangeNotification, object: self)
         .map { ($0.object as? UITextField)?.text  ?? "" }
         .eraseToAnyPublisher()
   }
}

// MARK: -- Text Field with Padding

class MainTextField: UITextField {
   
   let padding = UIEdgeInsets(top: 7, left: 12, bottom: 7, right: 12)
   
   override open func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
   }
   
   override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
   }
   
   override open func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
   }
}
