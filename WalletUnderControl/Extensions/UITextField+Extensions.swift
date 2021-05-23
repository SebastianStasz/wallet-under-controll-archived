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

// MARK: -- "Done Bar" for Keyboards

extension UITextField {
   func addActionButtonToKeyboard(title: String = "Done", action: UIAction) {
      let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
      doneToolbar.barStyle = .default
      
      let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
      let done = UIBarButtonItem(title: title, primaryAction: action)
      
      var items = [UIBarButtonItem]()
      items.append(flexSpace)
      items.append(done)
      
      doneToolbar.items = items
      doneToolbar.sizeToFit()
      
      inputAccessoryView = doneToolbar
   }
}

// MARK: -- Text Field with Padding

class MainTextField: UITextField {
   
   private let padding: UIEdgeInsets
   
   init(padding: UIEdgeInsets) {
      self.padding = padding
      super.init(frame: .zero)
   }
   
   override open func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
   }
   
   override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
   }
   
   override open func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}
