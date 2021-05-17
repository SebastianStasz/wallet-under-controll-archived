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
   static let shared = Currencies()
   
   private let context: NSManagedObjectContext
   private let currencyAPI: CurrencyAPIType
   private let dataService: APIService
   
   private let updateExchangeRates = PassthroughSubject<CurrencyEntity, Never>()
   private var cancellables: Set<AnyCancellable> = []
   private let currencyData = "currencyData"
   
   @Published private(set) var all: [CurrencyEntity] = [] 
   
   init(dataService: APIService = DataService.shared,
        currencyAPI: CurrencyAPIType = CurrencyAPI(),
        context: NSManagedObjectContext = SceneDelegate.context)
   {
      self.dataService = dataService
      self.currencyAPI = currencyAPI
      self.context = context
      
      print("Currencies Init")
      
      setupExchangeRatesUpdater()
      fetchCurrencies()
   }
   
   private func fetchCurrencies() {
      let request = CurrencyEntity.createFetchRequest()
      request.sortDescriptors = [CurrencyEntity.sortByCodeASC]
      request.predicate = nil
      
      do {
         all = try context.fetch(request)
         if all.count != 33 { createCurrencies() }
         else if !all.isEmpty { _ = all.map { updateExchangeRates.send($0) } }
      } catch let error {
         print("Fetching currencies error: \(error)")
      }
   }
}

// MARK: -- Updating Currencies

extension Currencies {
   
   private func setupExchangeRatesUpdater() {
      updateExchangeRates
         .filter { currency in
            guard let date = currency.updateDate else { return true }
            return date.timeIntervalSinceNow > 3600000
         }
         .sink { [unowned self] currency in
            updateExchangeRates(for: currency)
         }
         .store(in: &cancellables)
   }
   
   private func updateExchangeRates(for currency: CurrencyEntity) {
      let url = currencyAPI.getLatestExchangeRates(base: currency.code, forCurrencyCodes: all.map { $0.code })
      let currencyRatesData: AnyPublisher<ExchangeRateRequest, Error> = dataService.fetch(from: url)
      
      currencyRatesData
         .filter {
            let isValid = $0.base == currency.code
            assert(isValid) ; return isValid
         }
         .map { $0.rates }
         .sink { if case .failure(let error) = $0 {
            fatalError("Update exchange rates error: \(error)")
         }
         } receiveValue: { exchangeRates in
         _ = currency.exchangeRates.map { exchangeRate in
            let rateData = exchangeRates.first(where: { $0.key == exchangeRate.code })
            let rateValue = rateData?.value ?? 0
            exchangeRate.rateValue = rateValue
         }
      }
      .store(in: &cancellables)
   }
}

// MARK: -- Setup Currencies

extension Currencies {

   private func createCurrencies() {
      let url = Bundle.main.url(forResource: currencyData, withExtension: "json")!
      let currenciesData: AnyPublisher<[String : String], Error> = dataService.fetch(from: url)
      
      _ = all.map { context.delete($0) }
      
      currenciesData
         .sink { if case .failure(let error) = $0 {
            fatalError("Create currencies error: \(error)")
         }
         } receiveValue: { [unowned self] currenciesData in
            _ = currenciesData
               .map { CurrencyEntity.create(code: $0.0, name: $0.1, in: context) }
               .map { [unowned self] currency in
                  createExchangeRates(for: currency, currenciesData: currenciesData)
               }
            
            fetchCurrencies()
         }
         .store(in: &cancellables)
   }
   
   private func createExchangeRates(for currency: CurrencyEntity, currenciesData: [String : String]) {
      let otherCurrencies = currenciesData.filter({ $0.0 != currency.code })
      currency.updateDate = Date()
      
      for currencyData in otherCurrencies {
         ExchangeRateEntity.create(from: currency, to: currencyData.0, value: 0, in: context)
      }
   }
}
