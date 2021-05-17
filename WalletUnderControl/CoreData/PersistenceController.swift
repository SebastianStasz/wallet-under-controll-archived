//
//  PersistenceController.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//

import Combine
import CoreData

class PersistenceController {
   static let shared = PersistenceController()
   private var cancellables: Set<AnyCancellable> = []
   
   private let container: NSPersistentContainer
   let context: NSManagedObjectContext
   
   init(inMemory: Bool = false) {
      container = NSPersistentContainer(name: "WalletUnderControl")
      
      if inMemory {
         container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
      }
      
      container.loadPersistentStores { storeDescription, error in
         guard let error = error else { return }
         fatalError("Loading persistent stores error: \(error)")
      }
      
      context = container.viewContext
      saveContextPublisher()
   }
   
   private func save() {
      do {
         try context.save()
         print("Saving Context")
      }
      catch let error {
         // TODO: Temporary Fatal Error
         fatalError("Saving context error: \(error)")
      }
   }
   
   private func saveContextPublisher() {
      NotificationCenter.default
         .publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
         .debounce(for: .seconds(5), scheduler: DispatchQueue.main)
         .sink { [weak self] notification in self?.save() }
         .store(in: &cancellables)
   }
}

// MARK: -- Preview

extension PersistenceController {
   
   static var preview: PersistenceController = {
      let result = PersistenceController.init(inMemory: true)
      let viewContext = result.context
      
      _ = CoreDataSample.createWallets(context: viewContext)
      
      do {
         try viewContext.save()
      } catch let error {
         fatalError("CoreData preview saving error: \(error)")
      }
      
      return result
   }()
   
   static var empty: PersistenceController = {
      let result = PersistenceController.init(inMemory: true)
      let viewContext = result.context
      
      do {
         try viewContext.save()
      } catch let error {
         fatalError("CoreData preview saving error: \(error)")
      }
      
      return result
   }()
}

// MARK: -- Sample Data

struct CoreDataSample {
   
   static func createWallets(context: NSManagedObjectContext) -> [WalletEntity] {
      let currencies = createCurrencies(context: context)
      let names = ["Savings", "Main", "Investment", "Long Term"]
      let initialBalances: [Double] = [0, 200, 1000, 1000, 4250]
      let icons: [WalletIcon] = [.bag, .banknoteFill, .cart, .creditcardFill, .bagCircleFill]
      let iconColor: [IconColor] = [.blue1, .gray, .green2, .purple, .yellow]
      let walletTypes = createWalletTypes(context: context)
      
      var wallets: [WalletEntity] = []
      
      for i in names.indices {
         let wallet = WalletEntity(context: context)
         wallet.id = UUID()
         wallet.creationDate = Date()
         wallet.name = names[i]
         wallet.icon = icons[i]
         wallet.iconColor = iconColor[i]
         wallet.initialBalance = initialBalances[i]
         wallet.type = walletTypes.randomElement()!
         wallet.currency = currencies.randomElement()!
         
         wallets.append(wallet)
      }
      
      return wallets
   }
   
   static func createWallet(context: NSManagedObjectContext) -> WalletEntity {
      let currencies = createCurrencies(context: context)
      let walletType = createWalletType(context: context)
      
      let wallet = WalletEntity(context: context)
      wallet.id = UUID()
      wallet.creationDate = Date()
      wallet.name = "Savings"
      wallet.icon = .banknoteFill
      wallet.iconColor = .blue1
      wallet.initialBalance = 200
      wallet.type = walletType
      wallet.currency = currencies.randomElement()!
      
      return wallet
   }
   
   static func createWalletTypes(context: NSManagedObjectContext) -> [WalletTypeEntity] {
      let names = ["Getin Bank", "Card", "Savings"]
      var walletTypes: [WalletTypeEntity] = []
      
      for name in names {
         let walletType = WalletTypeEntity(context: context)
         walletType.name = name
         walletTypes.append(walletType)
      }
      
      return walletTypes
   }
   
   static func createWalletType(context: NSManagedObjectContext) -> WalletTypeEntity {
      let walletType = WalletTypeEntity(context: context)
      walletType.name = "Getin Bank"
      
      return walletType
   }
   
   static func createCurrencies(context: NSManagedObjectContext) -> [CurrencyEntity] {
      let url = Bundle.main.url(forResource: "currencyData", withExtension: "json")!
      let data = try! Data(contentsOf: url)
      let currenciesData = try! JSONDecoder().decode([String : String].self, from: data)
      
      let currencies = currenciesData.map { currencyData -> CurrencyEntity in
         let currency = CurrencyEntity(context: context)
         currency.code = currencyData.0
         currency.name = currencyData.1
         currency.updateDate = Date()
         
         let otherCurrencies = currenciesData.filter({ $0.0 != currency.code })
         
         for currencyData in otherCurrencies {
            ExchangeRateEntity.create(from: currency, to: currencyData.0, value: 0, in: context)
         }
         
         return currency
      }
      
      return currencies
   }
}
