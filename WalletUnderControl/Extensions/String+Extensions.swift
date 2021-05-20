//
//  String+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 18/05/2021.
//

import Foundation

extension String {
   func comasToDots() -> String {
      self.replacingOccurrences(of: ",", with: ".")
   }
}
