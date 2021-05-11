//
//  WalletEntityTests.swift
//  WalletUnderControlTests
//
//  Created by Sebastian Staszczyk on 10/05/2021.
//

import XCTest
@testable import WalletUnderControl

class WalletEntityTests: XCTestCase {
   
   private let context = PersistenceController.empty.context
   private let request = WalletEntity.createFetchRequest()
   
   override func setUpWithError() throws {
      context.reset()
   }
   
   override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
   }
   
   func testCreateWalletEntity() throws {
      let walletType = CoreDataSample.createWalletType(context: context)
      let currency = CoreDataSample.createCurrencies(context: context).first!
      let template = WalletTemplate(name: "Savings", icon: .banknote, iconColor: .gray, type: walletType, initialBalance: 300, currency: currency)
      
      let wallets1 = try! context.fetch(request)
      XCTAssert(wallets1.isEmpty)
      
      WalletEntity.create(in: context, using: template)
      
      let wallets2 = try! context.fetch(request)
      XCTAssertEqual(wallets2.count, 1, "One Wallet should be created.")
      
      let createdWallet = wallets2.first!
      XCTAssertNotNil(createdWallet.id)
      XCTAssertNotNil(createdWallet.creationDate)
      XCTAssertEqual(createdWallet.name, template.name)
      XCTAssertEqual(createdWallet.icon, template.icon)
      XCTAssertEqual(createdWallet.type, template.type)
      XCTAssertEqual(createdWallet.currency, template.currency)
      XCTAssertEqual(createdWallet.iconColor, template.iconColor)
      XCTAssertEqual(createdWallet.initialBalance, template.initialBalance)
   }
}
