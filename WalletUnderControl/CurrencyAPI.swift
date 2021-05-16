//
//  CurrencyAPI.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 15/05/2021.
//

import Foundation

struct CurrencyAPI {
   private let exchangeRatesURL = "https://api.exchangerate.host"
   private let startComponents: URLComponents
   
   init() {
      var startComponents = URLComponents()
      startComponents.scheme = "https"
      startComponents.host = "api.exchangerate.host"
      self.startComponents = startComponents
   }
   
   func getLatestExchangeRates(base currencyCode: String, forCurrencyCodes symbols: [String]) -> URL? {
      var urlComponents = startComponents
      let endpoint = Endpoint.latest(for: currencyCode, symbols: symbols)
      urlComponents.path = endpoint.path
      urlComponents.queryItems = endpoint.queryItems
      
      return urlComponents.url
   }
}

// MARK: -- Endpoints

extension CurrencyAPI {
   
    private struct Endpoint {
      let path: String
      let queryItems: [URLQueryItem]
      
      static func allLatest(for currencyCode: String) -> Endpoint {
         let base = Parameter.base(currencyCode).queryItem
         return Endpoint(path: "/latest", queryItems: [base])
      }
      
      static func latest(for currencyCode: String, symbols: [String]) -> Endpoint {
         let base = Parameter.base(currencyCode).queryItem
         let symbols = Parameter.symbols(symbols).queryItem
         return Endpoint(path: "/latest", queryItems: [base, symbols])
      }
   }
}

// MARK: -- Parameters

extension CurrencyAPI {
   
   private enum Parameter {
      case base(_ currencyCode: String)
      case symbols(_ symbols: [String])
      
      var queryItem: URLQueryItem {
         switch self {
         case .base(currencyCode: let currencyCode):
            return URLQueryItem(name: "base", value: currencyCode)
            
         case .symbols(let symbols):
            return URLQueryItem(name: "symbols", value: symbols.joined(separator: ","))
         }
      }
   }
}


