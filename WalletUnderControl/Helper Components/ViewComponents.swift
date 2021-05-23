//
//  ViewComponents.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 19/05/2021.
//

import UIKit

struct ViewComponents {
   
   static func mainButton(title: String) -> MainButton {
      let button = MainButton()
      button.layer.cornerRadius = 15
      button.backgroundColor = .systemBlue
      button.setTitle(title, for: .normal)
      button.setTitleColor(.white, for: .normal)
      button.setTitleColor(.systemGray, for: .disabled)
      button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
      
      return button
   }
   
   static func validationMessageLabel() -> PaddingLabel {
      let label = PaddingLabel(padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
      label.textColor = Typography.Color.validationRed
      label.font = Typography.validationMessage
      label.lineBreakMode = .byWordWrapping
      label.numberOfLines = .zero
      
      return label
   }
   
   static func mainTextField(title: String, placeholder: String, padding: UIEdgeInsets) -> MainTextField {
      let textField = MainTextField(padding: padding)
      let fieldLabel = UILabel()
      
      fieldLabel.text = "  \(title):  "
      textField.leftView = fieldLabel
      textField.leftViewMode = .always
      textField.textAlignment = .right
      textField.autocorrectionType = .no
      textField.borderStyle = .roundedRect
      textField.placeholder = placeholder
      textField.backgroundColor = .tertiarySystemBackground
      
      return textField
   }
}
