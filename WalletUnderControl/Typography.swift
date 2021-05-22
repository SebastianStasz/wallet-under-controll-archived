//
//  Typography.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 21/05/2021.
//

import UIKit

struct Typography {
   
   static let validationMessage = UIFont.systemFont(ofSize: 15, weight: .light)
   
   struct Color {
      static let validationRed = UIColor.systemRed
   }
}

// MARK: -- Helpers

extension Typography {
   
   static func getAlertValidationMessage(for text: String) -> NSMutableAttributedString {
      let attr1 = [NSAttributedString.Key.foregroundColor : Color.validationRed]
      let attr2 = [NSAttributedString.Key.font : validationMessage]
      let message = NSMutableAttributedString(string: text, attributes: attr1)
      message.addAttributes(attr2, range: NSRange(location: 0, length: text.count))
      return message
   }
}
