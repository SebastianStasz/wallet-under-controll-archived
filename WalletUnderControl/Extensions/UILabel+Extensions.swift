//
//  UILabel+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 13/05/2021.
//

import UIKit

// MARK: -- Label with Padding

class PaddingLabel: UILabel {
   
   private var padding: UIEdgeInsets
   
   init(padding: UIEdgeInsets = .zero) {
      self.padding = padding
      super.init(frame: .zero)
      setPadding(padding.top, padding.bottom, padding.left, padding.right)
   }
   
   func setPadding(_ top: CGFloat, _ bottom: CGFloat, _ left: CGFloat, _ right: CGFloat) {
      frame = CGRect(x: 0, y: 0, width: frame.width + left + right, height: frame.height + top + bottom)
      padding = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
   }
   
   override func drawText(in rect: CGRect) {
      super.drawText(in: rect.inset(by: padding))
   }
   
   override var intrinsicContentSize: CGSize {
      get {
         var contentSize = super.intrinsicContentSize
         contentSize.height += padding.top + padding.bottom
         contentSize.width += padding.left + padding.right
         return contentSize
      }
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

// MARK: -- Letter Spacing

extension UILabel {
   func addCharacterSpacing(kernValue: Double = 3) {
      if let labelText = text, !labelText.isEmpty {
         let attributedString = NSMutableAttributedString(string: labelText)
         attributedString.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
         attributedText = attributedString
      }
   }
}
