//
//  SettingsTests.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 11/05/2021.
//

import XCTest
@testable import WalletUnderControl

class SettingsTests: XCTestCase {
   
   private let currencies = CoreDataSample.createCurrencies(context: PersistenceController.empty.context)
   private var settings: Settings!
   
   override func setUpWithError() throws {
      let userDefaults = UserDefaults(suiteName: #file)!
      userDefaults.removePersistentDomain(forName: #file)
      settings = Settings(userDefaults: userDefaults)
   }
   
   override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
   }
   
   // MARK: -- Setting Currency Tests
   
   func test_set_currency() throws {
      XCTAssertEqual(settings.primaryCurrencyCode, "PLN", "Default value for primary currency should be PLN")
      XCTAssertEqual(settings.secondaryCurrencyCode, "EUR", "Default vaule for secondary currency should be EUR")
      
      let usd = currencies.first(where: { $0.code == "USD" })!
      settings.setCurrency(usd, for: .primary)
      
      XCTAssertEqual(settings.primaryCurrencyCode, "USD", "Primary currency should be now USD")
      XCTAssertEqual(settings.secondaryCurrencyCode, "EUR", "Secondary currency should be still EUR")
      
      let cad = currencies.first(where: { $0.code == "CAD" })!
      settings.setCurrency(cad, for: .secondary)
      
      XCTAssertEqual(settings.primaryCurrencyCode, "USD", "Primary currency should still USD")
      XCTAssertEqual(settings.secondaryCurrencyCode, "CAD", "Secondary currency should be now CAD")
   }
   
   func test_set_primary_currency_same_as_secondary_currency() throws {
      XCTAssertEqual(settings.primaryCurrencyCode, "PLN", "Default value for primary currency should be PLN")
      XCTAssertEqual(settings.secondaryCurrencyCode, "EUR", "Default vaule for secondary currency should be EUR")
      
      let eur = currencies.first(where: { $0.code == "EUR" })!
      settings.setCurrency(eur, for: .primary)
      
      XCTAssertEqual(settings.primaryCurrencyCode, "EUR", "Primary currency should be now EUR")
      XCTAssertEqual(settings.secondaryCurrencyCode, "PLN", "Secondary currency should be now PLN (previous value of primary)")
   }
   
   func test_set_secondary_currency_same_as_primary_currency() throws {
      XCTAssertEqual(settings.primaryCurrencyCode, "PLN", "Default value for primary currency should be PLN")
      XCTAssertEqual(settings.secondaryCurrencyCode, "EUR", "Default vaule for secondary currency should be EUR")
      
      let pln = currencies.first(where: { $0.code == "PLN" })!
      settings.setCurrency(pln, for: .secondary)
      
      XCTAssertEqual(settings.secondaryCurrencyCode, "PLN", "Secondary currency should be now PLN")
      XCTAssertEqual(settings.primaryCurrencyCode, "EUR", "Primary currency should be now EUR (previous value of secondary)")
   }
}
