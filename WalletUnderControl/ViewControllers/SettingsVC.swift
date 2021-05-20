//
//  SettingsVC.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 10/05/2021.
//

import UIKit

class SettingsVC: UIViewController {
   private let settings: SettingsProtocol
   
   private let settingsTB = UITableView(frame: .zero, style: .insetGrouped)
   private let currencies: Currencies
   
   var sections: [SettingsSection] = []
   
   init(settings: SettingsProtocol = Settings(), currencies: Currencies = Currencies.shared) {
      self.settings = settings
      self.currencies = currencies
      super.init(nibName: nil, bundle: nil)
      settingsTB.delegate = self
      settingsTB.dataSource = self
      
      sections = [
         .init(title: "Categories", options: [
            .init(title: "Wallet Types") { [unowned self] in presentVC(GroupingEntityListVC<WalletTypeEntity>()) },
            .init(title: "Income Categories") { [unowned self] in presentVC(GroupingEntityListVC<CashFlowCategoryEntity>(for: .income)) },
            .init(title: "Expense Catogories") { [unowned self] in presentVC(GroupingEntityListVC<CashFlowCategoryEntity>(for: .expense)) },
         ]),
         .init(title: "Currencies", options: [
            
            .init(title: "Primary", value: settings.primaryCurrencyCode, handler: { [unowned self] in
               let picker = CurrencyListVC.Picker(title: "Primary Currency", selectedCurrency: settings.primaryCurrencyCode) { currency in
                  settings.setCurrency(currency, for: .primary)
                  reloadView()
               }
               
               let currencyListVC = CurrencyListVC(currencies: currencies, picker: picker)
               presentVC(currencyListVC)
            }),
            
            .init(title: "Secondary", value: settings.secondaryCurrencyCode, handler: { [unowned self] in
               let picker = CurrencyListVC.Picker(title: "Secondary Currency", selectedCurrency: settings.secondaryCurrencyCode) { currency in
                  settings.setCurrency(currency, for: .secondary)
                  reloadView()
               }
               let currencyListVC = CurrencyListVC(currencies: currencies, picker: picker)
               presentVC(currencyListVC)
            })
         ]),
      ]
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      settingsTB.rowHeight = SettingsCell.height
      settingsTB.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.id)
      
      title = "Settings"
      navigationController?.navigationBar.prefersLargeTitles = true
      
      view = settingsTB
   }
   
   private func reloadView() {
      sections[1].options[0].value = settings.primaryCurrencyCode
      sections[1].options[1].value = settings.secondaryCurrencyCode
      settingsTB.reloadData()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

// MARK: -- TableView Configuration

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      sections.count
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      sections[section].options.count
   }
   
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      sections[section].title
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.id, for: indexPath) as! SettingsCell
      let option = sections[indexPath.section].options[indexPath.row]
      cell.configure(with: option)
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      let option = sections[indexPath.section].options[indexPath.row]
      option.handler()
   }
}

// MARK: -- Intents

extension UIViewController {
   func presentVC(_ viewController: UIViewController) {
      self.navigationController?.pushViewController(viewController, animated: true)
   }
}
