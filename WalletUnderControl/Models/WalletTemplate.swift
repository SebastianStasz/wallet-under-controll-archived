//
//  WalletTemplate.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 10/05/2021.
//

import Foundation

struct WalletTemplate {
   let name: String
   let icon: WalletIcon
   let iconColor: IconColor
   let type: WalletTypeEntity
   let initialBalance: Double
   let currency: CurrencyEntity
}
