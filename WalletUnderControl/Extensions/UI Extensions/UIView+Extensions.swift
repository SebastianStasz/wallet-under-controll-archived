//
//  UIView+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 26/05/2021.
//

import UIKit

extension UIView {
   
   func setGradientBackground(color1: UIColor, color2: UIColor) {
      setGradientBackground(color1: color1, color2: color2, width: frame.width, height: frame.height)
   }
   
   func setGradientBackground(color1: UIColor, color2: UIColor, width: CGFloat, height: CGFloat) {
      let gradientLayer = CAGradientLayer()
      gradientLayer.locations = [NSNumber(floatLiteral: 0.0), NSNumber(floatLiteral: 1.0)]
      gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
      gradientLayer.colors = [color1.cgColor, color2.cgColor]
      gradientLayer.startPoint = CGPoint(x: 0, y: 0)
      gradientLayer.endPoint = CGPoint(x: 1, y: 1)
      
      layer.insertSublayer(gradientLayer, at: 0)
   }
}
