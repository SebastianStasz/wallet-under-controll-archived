//
//  UIButton+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 12/05/2021.
//

import UIKit

extension UIButton {
   
   // MARK: -- Main Animation when Clicked
   
   func zoomIn(duration: TimeInterval = 0.2) {
      transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
      
      UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { [unowned self] in
         transform = .identity
      }) { (animationCompleted: Bool) -> Void in }
   }
}

// MARK: -- Button opacity if disabled / enabled

class MainButton: UIButton {
    override var isEnabled: Bool {
        didSet { alpha = isEnabled ? 1.0 : 0.5 }
    }
}
