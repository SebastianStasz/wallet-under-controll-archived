//
//  IconColor.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//

import UIKit

extension IconColor: CaseIterable {}

enum IconColor: Int16 {
   case red
   case orange
   case yellow
   case green1
   case green2
   case blue1
   case blue2
   case purple
   case pink
   case gray
   
   var color: UIColor {
      switch self {
      case .red:
         return UIColor(red: 1, green: 0, blue: 0, alpha: 1)
      case .orange:
         return UIColor(red: 1, green: 128/255, blue: 0, alpha: 1)
      case .yellow:
         return UIColor(red: 1, green: 1, blue: 0, alpha: 1)
      case .green1:
         return UIColor(red: 128/255, green: 1, blue: 0, alpha: 1)
      case .green2:
         return UIColor(red: 0, green: 1, blue: 0, alpha: 1)
      case .blue1:
         return UIColor(red: 0, green: 0, blue: 1, alpha: 1)
      case .blue2:
         return UIColor(red: 0, green: 1, blue: 1, alpha: 1)
      case .purple:
         return UIColor(red: 127/255, green: 0, blue: 1, alpha: 1)
      case .pink:
         return UIColor(red: 1, green: 0, blue: 127/255, alpha: 1)
      case .gray:
         return UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
      }
   }
}
