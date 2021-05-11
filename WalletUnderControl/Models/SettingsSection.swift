//
//  SettingsSection.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 10/05/2021.
//

import Foundation

struct SettingsSection {
   let title: String
   var options: [SettingsOption]
}

struct SettingsOption {
   let title: String
   var value: String? = nil
   let handler: () -> Void
}
