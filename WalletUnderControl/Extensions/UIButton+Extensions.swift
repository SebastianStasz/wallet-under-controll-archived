//
//  UIButton+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 12/05/2021.
//

import UIKit

extension UIButton {
   
   func zoomIn(duration: TimeInterval = 0.2) {
      transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      
      UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { [unowned self] in
         transform = .identity
      }) { (animationCompleted: Bool) -> Void in }
   }
}
