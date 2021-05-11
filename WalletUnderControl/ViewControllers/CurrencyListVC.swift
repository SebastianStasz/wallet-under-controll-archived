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
   
   init(currencies: Currencies = Currencies(), picker: Picker? = nil) {
      self.currencies = currencies
      self.picker = picker
      super.init(nibName: nil, bundle: nil)
      
      currencyTBV.delegate = self
      currencyTBV.dataSource = self
      
      currencies.$all
         .sink { [unowned self] _ in
            currencyTBV.reloadData()
         }
         .store(in: &cancellables)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      currencyTBV.rowHeight = CurrencyCell.height
      currencyTBV.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.id)
      
      view = currencyTBV
      title = picker?.title ?? "Currencies"
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
      
      picker?.selectRowHandler(currency)
      navigationController?.popViewController(animated: true)
   }
}

// MARK: -- Picker Functionality

extension CurrencyListVC {
   struct Picker {
      let title: String?
      let selectedCurrency: String
      let selectRowHandler: (_ currency: CurrencyEntity) -> Void
      
      init(title: String? = nil, selectedCurrency: String, selectRowHandler: @escaping (_ currency: CurrencyEntity) -> Void) {
         self.title = title
         self.selectedCurrency = selectedCurrency
         self.selectRowHandler = selectRowHandler
      }
   }
}
