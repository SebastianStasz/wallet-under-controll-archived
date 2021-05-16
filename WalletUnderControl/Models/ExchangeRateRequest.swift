//
//  ExchangeRateRequest.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 15/05/2021.
//

import Foundation

struct ExchangeRateRequest: Decodable {
   let base: String
   let date: String
   let rates: [String : Double]
}
