//
//  Currencies.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//

import Combine
import CoreData
import Foundation

class Currencies: ObservableObject {
   private var cancellables: Set<AnyCancellable> = []
   private let currencyData = "currencyData"
   
   private let context: NSManagedObjectContext
   private let dataService: APIService
   
   @Published private(set) var all: [CurrencyEntity] = []
   
   init(context: NSManagedObjectContext = SceneDelegate.context, dataService: APIService = DataService.shared) {
      self.context = context
      self.dataService = dataService
      fetchCurrencies()
   }
   
   private func fetchCurrencies() {
      let request = CurrencyEntity.createFetchRequest()
      request.sortDescriptors = [CurrencyEntity.sortByCodeASC]
      request.predicate = nil
      
      do {
         all = try context.fetch(request)
         if all.count < 33 { createCurrencies() }
      } catch let error {
         print("Fetching currencies error: \(error)")
      }
   }
   
   private func createCurrencies() {
      print("Creating Currencies")
      let url = Bundle.main.url(forResource: currencyData, withExtension: "json")!
      let currenciesData: AnyPublisher<[String : String], Error> = dataService.fetch(from: url)
      
      currenciesData
         .sink { completion in
            print(completion)
         } receiveValue: { [unowned self] currenciesData in
            _ = currenciesData.map { currencyData in
               if !all.contains(where: { $0.code == currencyData.0 }) {
                  let currency = CurrencyEntity(context: context)
                  currency.code = currencyData.0
                  currency.name = currencyData.1
               }
            }
            fetchCurrencies()
         }
         .store(in: &cancellables)
   }
}
