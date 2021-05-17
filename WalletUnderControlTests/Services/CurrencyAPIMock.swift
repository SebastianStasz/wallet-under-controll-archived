//
//  CurrencyAPIMock.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//

import Foundation
@testable import WalletUnderControl

class CurrencyAPIMock: CurrencyAPIType {
   
   func getLatestExchangeRates(base currencyCode: String, forCurrencyCodes symbols: [String]) -> URL? {
      Bundle.main.url(forResource: "sample_EUR_exchange_rates", withExtension: "json")!
   }
}
