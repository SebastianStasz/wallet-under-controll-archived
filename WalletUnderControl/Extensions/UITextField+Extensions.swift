//
//  UITextField+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 12/05/2021.
//

import Combine
import UIKit

extension UITextField {
   func textPublisher() -> AnyPublisher<String, Never> {
      NotificationCenter.default
         .publisher(for: UITextField.textDidChangeNotification, object: self)
         .map { ($0.object as? UITextField)?.text  ?? "" }
         .eraseToAnyPublisher()
   }
}
