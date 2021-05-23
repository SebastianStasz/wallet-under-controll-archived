//
//  CurrencyListVC.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 09/05/2021.
//

import Combine
import UIKit

class CurrencyListVC: UIViewController {
   private var cancellables: Set<AnyCancellable> = []
   private let currencies: Currencies
   private let picker: Picker?
   
   private let currencyTBV = UITableView()
   
   init(currencies: Currencies = Currencies.shared, picker: Picker? = nil) {
      self.currencies = currencies
      self.picker = picker
      super.init(nibName: nil, bundle: nil)
      
      currencies.$all
         .receive(on: DispatchQueue.main)
         .sink { [unowned self] _ in
            currencyTBV.reloadData()
         }
         .store(in: &cancellables)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      currencyTBV.delegate = self
      currencyTBV.dataSource = self
      
      currencyTBV.rowHeight = CurrencyCell.height
      currencyTBV.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.id)
      
      navigationController?.navigationBar.prefersLargeTitles = true
      title = picker?.title ?? "Currencies"
      
      view = currencyTBV
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

// MARK: -- TableView Configuration

extension CurrencyListVC: UITableViewDelegate, UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      currencies.all.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.id) as! CurrencyCell
      let currency = currencies.all[indexPath.row]
      let isSelected = picker?.selectedCurrency == currency.code
      cell.configure(with: currency, isSelected: isSelected)
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      let currency = currencies.all[indexPath.row]
      
      if let picker = picker {
         picker.selectRowHandler(currency)
      } else {
         presetExchangeRates(for: currency)
      }
      
      navigationController?.popViewController(animated: true)
   }
}

// MARK: -- Currency Detail View Configuration

extension CurrencyListVC {
   
   private func presetExchangeRates(for currency: CurrencyEntity) {
      let exchangeRatesVC = getExchangeRatesVC(for: currency)
      let exchangeRatesNC = UINavigationController(rootViewController: exchangeRatesVC)
      
      present(exchangeRatesNC, animated: true)
   }
   
   private func getExchangeRatesVC(for currency: CurrencyEntity) -> UIViewController {
      var exchangeRates = currency.exchangeRates.map{ $0 }
      exchangeRates.sort(by: { $0.code < $1.code })
      
      let exchangeRatesVC = TableViewController(items: exchangeRates) { (cell: CurrencyCell, rate) in
         cell.configure(with: rate)
      }
      
      let showCurrencyInfoAlert = UIAction() { [unowned self] _ in
         let alert = getCurrencyInfoAlert(for: currency)
         exchangeRatesVC.present(alert, animated: true)
      }
      
      let infoBTN = UIBarButtonItem(title: nil, image: UIImage(systemName: "info.circle"), primaryAction: showCurrencyInfoAlert)
      exchangeRatesVC.title = "Exchange rates for: \(currency.code)"
      exchangeRatesVC.navigationItem.leftBarButtonItem = infoBTN
      
      return exchangeRatesVC
   }
   
   private func getCurrencyInfoAlert(for currency: CurrencyEntity) -> UIAlertController {
      let title = "\(currency.code) Info"
      let updateDate = currency.updateDate.string(format: .short, withTime: true)
      let msg = "Data from: exchangerate.host\nLast update: \(updateDate)."
      
      let ac = UIAlertController(title: title, message: msg, preferredStyle: .alert)
      ac.addAction(.okAction)
      
      return ac
   }
}

// MARK: -- Picker Functionality

extension CurrencyListVC {
   struct Picker {
      let title: String?
      let selectedCurrency: String?
      let selectRowHandler: (_ currency: CurrencyEntity) -> Void
      
      init(title: String? = nil, selectedCurrency: String?, selectRowHandler: @escaping (_ currency: CurrencyEntity) -> Void) {
         self.title = title
         self.selectedCurrency = selectedCurrency
         self.selectRowHandler = selectRowHandler
      }
   }
}
