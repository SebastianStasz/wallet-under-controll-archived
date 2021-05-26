//
//  WalletEntity+CoreDataProperties.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//
//

import Foundation
import CoreData
import UIKit


@objc(WalletEntity)
public class WalletEntity: NSManagedObject {
   
   @nonobjc public class func createFetchRequest() -> NSFetchRequest<WalletEntity> {
      return NSFetchRequest<WalletEntity>(entityName: "WalletEntity")
   }
   
   @NSManaged public var id: UUID
   @NSManaged private var icon_: Int16
   @NSManaged private var iconColor_: Int16
   @NSManaged private(set) var name: String
   @NSManaged private(set) var creationDate: Date
   @NSManaged private(set) var initialBalance: Double
   @NSManaged private(set) var availableBalance: Double
   @NSManaged private(set) var type: WalletTypeEntity
   @NSManaged private(set) var currency: CurrencyEntity
   @NSManaged private(set) var cashFlows: [CashFlowEntity]
   
   private(set) var icon: WalletIcon {
      get { WalletIcon(rawValue: icon_)! }
      set { icon_ = newValue.rawValue }
   }
   
   private(set) var iconColor: IconColor {
      get { IconColor(rawValue: iconColor_)! }
      set { iconColor_ = newValue.rawValue }
   }
   
   /// Returns available balance, formatted in the currency of the wallet.
   var availableBalanceStr: String {
      availableBalance.toCurrency(currency.code)
   }
   
   /// Returns available balance, formatted in the specified currency code.
   func availableBalanceStr(in currencyCode: String) -> String? {
      let exchangeRate = currency.exchangeRates.first(where: { $0.code == currencyCode })
      assert(exchangeRate != nil, "Exchange Rate should exist in database.")
      return exchangeRate != nil ? (availableBalance * exchangeRate!.rateValue).toCurrency(currencyCode) : nil
   }
   
   /// Returns a UIImageView with a wallet icon in the color of the wallet icon.
   var iconView: UIImageView {
      let iconView = UIImageView(image: icon.img)
      iconView.tintColor = iconColor.color
      return iconView
   }
}

// MARK: -- Static Properties

extension WalletEntity {
   
   /// Sort by WalletEntity.name, ascending.
   static let sortByNameASC = NSSortDescriptor(keyPath: \WalletEntity.name, ascending: true)
}

// MARK: -- Methods

extension WalletEntity {

   static func create(in context: NSManagedObjectContext, using template: WalletTemplate) {
      let wallet = WalletEntity(context: context)
      wallet.id = UUID()
      wallet.creationDate = Date()
      wallet.initialBalance = template.initialBalance
      wallet.availableBalance = template.initialBalance
      wallet.update(using: template)
   }
   
   func update(using template: WalletTemplate) {
      let name = template.name.trimmingCharacters(in: .whitespacesAndNewlines)
      
      self.name = name
      icon = template.icon
      iconColor = template.iconColor
      type = template.type
      currency = template.currency
   }
   
   func increaseBalance(by value: Double) {
      self.availableBalance += value
   }
   
   func decreaseBalance(by value: Double) {
      self.availableBalance -= value
   }
}

// MARK: -- Generated accessors for cashFlows

extension WalletEntity {
   
   @objc(addCashFlowsObject:)
   @NSManaged public func addToCashFlows(_ value: CashFlowEntity)
   
   @objc(removeCashFlowsObject:)
   @NSManaged public func removeFromCashFlows(_ value: CashFlowEntity)
   
   @objc(addCashFlows:)
   @NSManaged public func addToCashFlows(_ values: NSSet)
   
   @objc(removeCashFlows:)
   @NSManaged public func removeFromCashFlows(_ values: NSSet)
   
}

extension WalletEntity: Identifiable {}


// MARK: -- Sample Data

extension WalletEntity {
   
   static func createWallets(context: NSManagedObjectContext) -> [WalletEntity] {
      let currencies = CurrencyEntity.createCurrencies(context: context)
      let names = ["Savings", "Main", "Investment", "Long Term"]
      let initialBalances: [Double] = [0, 200, 1000, 1000, 4250]
      let icons: [WalletIcon] = [.bag, .banknoteFill, .cart, .creditcardFill, .bagCircleFill]
      let iconColor: [IconColor] = [.blue1, .gray, .green2, .purple, .yellow]
      let walletTypes = WalletTypeEntity.createWalletTypes(context: context)
      
      var wallets: [WalletEntity] = []
      
      for i in names.indices {
         let wallet = WalletEntity(context: context)
         wallet.id = UUID()
         wallet.creationDate = Date()
         wallet.name = names[i]
         wallet.icon = icons[i]
         wallet.iconColor = iconColor[i]
         wallet.initialBalance = initialBalances[i]
         wallet.availableBalance = initialBalances[i]
         wallet.type = walletTypes.randomElement()!
         wallet.currency = currencies.randomElement()!
         
         wallets.append(wallet)
      }
      
      return wallets
   }
   
   static func createWallet(context: NSManagedObjectContext, initialBalance: Double = 200) -> WalletEntity {
      let currencies = CurrencyEntity.createCurrencies(context: context)
      let walletType = WalletTypeEntity.createWalletType(context: context)
      
      let wallet = WalletEntity(context: context)
      wallet.id = UUID()
      wallet.creationDate = Date()
      wallet.name = "Savings"
      wallet.icon = .banknoteFill
      wallet.iconColor = .blue1
      wallet.initialBalance = initialBalance
      wallet.availableBalance = initialBalance
      wallet.type = walletType
      wallet.currency = currencies.randomElement()!
      
      return wallet
   }
}
