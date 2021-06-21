//
//  UITableView+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 22/05/2021.
//

import UIKit

extension UITableView {
   
   func setEmptyView(_ view: UIView) {
      backgroundView = view
      separatorStyle = .none
   }
   
   func setEmptyMessage(_ message: String) {
      let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
      let messageLabel = PaddingLabel(padding: padding)
      messageLabel.text = message
      
      messageLabel.numberOfLines = 0
      messageLabel.textAlignment = .center
      messageLabel.textColor = .systemGray2
      messageLabel.sizeToFit()
      
      backgroundView = messageLabel
      separatorStyle = .none
   }
   
   func restore() {
      backgroundView = nil
      separatorStyle = .singleLine
   }
}
