//
//  WalletFormVC.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 13/05/2021.
//

import Combine
import CoreData
import UIKit

class WalletFormVC: UIViewController {
   private var walletTypes: FetchedResultsController<WalletTypeEntity>
   private let wallets: FetchedResultsController<WalletEntity>
   private let validationManager: ValidationService
   private let context: NSManagedObjectContext
   private let settings: SettingsProtocol
   private let currencies: Currencies
   
   private var cancellables: Set<AnyCancellable> = []
   private var walletFormView = WalletFormView()
   private var form = WalletFormVC.Form()
   private let wallet: WalletEntity?
   
   /// Without specifing, fetched results controllers will be created in given context.
   init(wallet: WalletEntity?,
        currencies: Currencies = Currencies.shared,
        settings: SettingsProtocol = Settings(),
        context: NSManagedObjectContext = SceneDelegate.context,
        validationManager: ValidationService = ValidationManager(),
        wallets: FetchedResultsController<WalletEntity>? = nil,
        walletTypes: FetchedResultsController<WalletTypeEntity>? = nil)
   {
      self.wallet = wallet
      self.context = context
      self.settings = settings
      self.currencies = currencies
      self.validationManager = validationManager
      self.wallets = wallets ?? WalletEntity.fetchedResultsController(in: context)
      self.walletTypes = walletTypes ?? WalletTypeEntity.fetchedResultsController(in: context)
      super.init(nibName: nil, bundle: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      walletFormView.pickerView.delegate = self
      walletFormView.pickerView.dataSource = self
      
      startFormValidation()
      setupUserInteractions()
      
      if let wallet = wallet {
         form.enterValuesFor(wallet)
         walletFormView.setupForEditing(wallet)
         title = "Edit '\(wallet.name)'"
      } else {
         let walletType = walletTypes.fetchedResultsController.fetchedObjects?.first as? WalletTypeEntity
         let currency = currencies.all.first(where: { $0.code == settings.primaryCurrencyCode })
         walletFormView.selectedWalletTypeLabel.text = walletType?.name
         walletFormView.selectedCurrencyLabel.text = currency?.code
         form.walletType = walletType
         form.currency = currency
         title = "Create Wallet"
      }
  
      let iconIndex = WalletIcon.allCases.firstIndex(of: form.icon)!
      let colorIndex = IconColor.allCases.firstIndex(of: form.iconColor)!
      walletFormView.pickerView.selectRow(colorIndex, inComponent: 0, animated: true)
      walletFormView.pickerView.selectRow(iconIndex, inComponent: 1, animated: true)

      navigationController?.navigationBar.prefersLargeTitles = true
      view = walletFormView
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

// MARK: -- Form Validation

extension WalletFormVC {
   
   private func startFormValidation() {
      Publishers.CombineLatest3(nameValidation, balanceValidation, walletTypeValidation)
         .map { name, balance, walletType in
            name == .isValid && balance == .isValid && walletType
         }
         .sink { [unowned self] isValid in
            walletFormView.submitButton.isEnabled = isValid
         }
         .store(in: &cancellables)
   }
   
   private var nameValidation: AnyPublisher<NameValidation, Never> {
      let wallets = wallets.fetchedResultsController.fetchedObjects  as? [WalletEntity]
      let usedNames = (wallets ?? []).map { $0.name }.filter { $0 != wallet?.name }
      
      return walletFormView.nameTextField.textPublisher()
         .debounce(for: 0.3, scheduler: RunLoop.main)
         .map { [unowned self] text in
            let validation = validationManager.validateName(text, usedNames: usedNames)
            walletFormView.nameValidationLabel.text = validation.message
            form.name = text
            return validation
         }
         .eraseToAnyPublisher()
   }
   
   private var balanceValidation: AnyPublisher<BalanceValidation, Never> {
      walletFormView.balanceTextField.textPublisher()
         .debounce(for: 0.3, scheduler: RunLoop.main)
         .map { [unowned self] value in
            let validation = validationManager.validateCurrency(value, canEqualZero: true)
            walletFormView.balanceValidationLabel.text = validation.message(fieldName: "Balance")
            form.initialBalance = Double(value.replacingOccurrences(of: ",", with: "."))
            return validation
         }
         .eraseToAnyPublisher()
   }
   
   private var walletTypeValidation: AnyPublisher<Bool, Never> {
      form.$walletType.map { [unowned self] in
         let isSelected = $0 != nil
         walletFormView.walletTypePickerValidationLabel.text = isSelected ? nil : "Wallet type is not selected."
         return isSelected
      }
      .eraseToAnyPublisher()
   }
}

// MARK: -- User Interactions

extension WalletFormVC {
   
   @objc private func dismissWalletForm() {
      dismiss(animated: true)
   }
   
   private func setupUserInteractions() {
      let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissWalletForm))
      
      let selectCurrency = UIAction() { [unowned self] _ in
         let picker = CurrencyListVC.Picker(title: "Select Currency", selectedCurrency: form.currency?.code) { currency in
            walletFormView.selectedCurrencyLabel.text = currency.code
            form.currency = currency
         }
         
         let currencyListVC = CurrencyListVC(picker: picker)
         navigationController?.pushViewController(currencyListVC, animated: true)
      }
      
      let selectWalletType = UIAction() { [unowned self] _ in
         let picker = WalletTypeListVC.Picker(title: "Select Type", selectedType: form.walletType) { walletType in
            walletFormView.selectedWalletTypeLabel.text = walletType.name
            form.walletType = walletType
         }
         
         let currencyListVC = WalletTypeListVC(picker: picker, walletTypes: walletTypes, context: context)
         navigationController?.pushViewController(currencyListVC, animated: true)
      }
      
      let submitFormAction = UIAction() { [unowned self] _ in
         guard let walletTemplate = WalletTemplate(using: form) else { return }
         
         if let wallet = wallet {
            wallet.update(using: walletTemplate)
         } else {
            WalletEntity.create(in: context, using: walletTemplate)
         }
         
         dismiss(animated: true)
      }
      
      walletFormView.submitButton.addAction(submitFormAction, for: .touchUpInside)
      walletFormView.selectCurrencyBTN.addAction(selectCurrency, for: .touchUpInside)
      walletFormView.selectWalletTypeBTN.addAction(selectWalletType, for: .touchUpInside)
      navigationItem.rightBarButtonItem = cancel
   }
}

// MARK: -- Wallet Icon & Icon Color Picker

extension WalletFormVC: UIPickerViewDelegate, UIPickerViewDataSource {
   
   func numberOfComponents(in pickerView: UIPickerView) -> Int { 2 }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      component == 1 ? WalletIcon.allCases.count : IconColor.allCases.count
   }
   
   func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
      let isIcon = component == 1
      
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
      imageView.contentMode = .scaleAspectFit
      let imageName = isIcon ? WalletIcon.allCases[row].name : "circle.fill"
      imageView.tintColor = isIcon ? form.iconColor.color : IconColor.allCases[row].color
      imageView.image = UIImage(systemName: imageName)
      
      return imageView
   }
   
   func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat { 45 }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      let isIcon = component == 1
      if isIcon { form.icon = WalletIcon.allCases[row] }
      else { form.iconColor = IconColor.allCases[row] }
      pickerView.reloadAllComponents()
   }
}

extension WalletFormVC {
   class Form {
      var name: String = ""
      var icon: WalletIcon = .creditcardFill
      var iconColor: IconColor = .purple
      var initialBalance: Double?
      var currency: CurrencyEntity?
      @Published var walletType: WalletTypeEntity?
      
      func enterValuesFor(_ wallet: WalletEntity) {
         name = wallet.name
         icon = wallet.icon
         iconColor = wallet.iconColor
         initialBalance = wallet.initialBalance
         currency = wallet.currency
         walletType = wallet.type
      }
   }
}
