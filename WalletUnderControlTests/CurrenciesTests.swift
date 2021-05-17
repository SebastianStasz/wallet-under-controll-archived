//
//  CurrenciesTests.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//

import XCTest
import CoreData
@testable import WalletUnderControl

class CurrenciesTests: XCTestCase {

   private var context = PersistenceController.empty.context
   private var currencyAPI: CurrencyAPIType!
   private var dataService: APIService!
   
   private var currencies: Currencies!
   
   override func setUpWithError() throws {
      context.reset()
      currencyAPI = CurrencyAPIMock()
      dataService = DataService()
   }
}
