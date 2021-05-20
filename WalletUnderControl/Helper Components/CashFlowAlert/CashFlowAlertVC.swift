//
//  CashFlowAlertVC.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 18/05/2021.
//

import Combine
import CoreData
import UIKit

class CashFlowAlertVC: UIViewController {
   @Published private var selectedCategory: CashFlowCategoryEntity?
   private var cashFlowCategoryAlert: GroupingEntityAlert<CashFlowCategoryEntity>? = nil
   private var cancellables: Set<AnyCancellable> = []
   
   private let cashFlowController: FetchedResultsController<CashFlowCategoryEntity>
   private let validationManager: ValidationService
   private let context: NSManagedObjectContext
   private let cashFlowType: CashFlowType
   private let cashFlow: CashFlowEntity?
   private let wallet: WalletEntity
   
   // UI Components
   private var nameTextField: MainTextField!
   private var amountTextField: MainTextField!
   private let categoryPicker = UIPickerView()
   private let datePicker = UIDatePicker()
   private var nameValidationLabel = ViewComponents.validationMessageLabel()
   private var amountValidationLabel = ViewComponents.validationMessageLabel()
   private var categoryValidationLabel = ViewComponents.validationMessageLabel()
   let submitBTNTitle: String
   let alertTitle: String
   
   @Published private(set) var isValid = false
   
   private var cashFlowCategories: [CashFlowCategoryEntity] {
      cashFlowController.fetchedResultsController.fetchedObjects as! [CashFlowCategoryEntity]
   }
   
   private init(
      cashFlow: CashFlowEntity?,
      type: CashFlowType,
      wallet: WalletEntity,
      validationManager: ValidationService,
      context: NSManagedObjectContext
   ) {
      self.context = context
      self.wallet = wallet
      self.cashFlow = cashFlow
      self.cashFlowType = type
      self.validationManager = validationManager
      
      let predicate = CashFlowCategoryEntity.filterByType(type)
      let sort = CashFlowCategoryEntity.sortByNameASC
      cashFlowController = CashFlowCategoryEntity.fetchedResultsController(in: context, predicate: predicate, sorting: [sort])
      
      alertTitle = type == .income ? "Income" : "Expense"
      submitBTNTitle = cashFlow == nil ? "Add" : "Update"
      super.init(nibName: nil, bundle: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad() ; setupView()
      categoryPicker.delegate = self
      categoryPicker.dataSource = self
      cashFlowController.fetchedResultsController.delegate = self
      
      Publishers.CombineLatest3(nameValidation, amountValidation, $selectedCategory)
         .map { $0 && $1 && $2 != nil}
         .assign(to: &$isValid)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

// MARK: -- View Setup

extension CashFlowAlertVC {
   
   private func setupView() {
      let textFieldPadding = UIEdgeInsets(top: 3, left: 12, bottom: 3, right: 12)
      
      // Date Picker
      datePicker.date = cashFlow?.date ?? Date()
      datePicker.preferredDatePickerStyle = .compact
      datePicker.datePickerMode = .date
      
      // Name Text Field
      nameTextField = ViewComponents.mainTextField(title: "Name", placeholder: cashFlowType.name, padding: textFieldPadding)
      let nameRowStackView = UIStackView(arrangedSubviews: [nameTextField, nameValidationLabel])
      nameTextField.keyboardType = .decimalPad
      nameRowStackView.axis = .vertical
      
      // Amount Text Field
      amountTextField = ViewComponents.mainTextField(title: "Amount", placeholder: "45", padding: textFieldPadding)
      let amountRowStackView = UIStackView(arrangedSubviews: [amountTextField, amountValidationLabel])
      amountTextField.keyboardType = .decimalPad
      amountRowStackView.axis = .vertical
      
      // Category Picker
      categoryValidationLabel.text = "No \(cashFlowType.name.lowercased()) categories, create one first."
      setCategoryPickerVisibility()
      
      // Add Category Button
      let addCategoryAction = UIAction() { [unowned self] _ in
         cashFlowCategoryAlert = GroupingEntityAlert<CashFlowCategoryEntity>(cashFlowType: cashFlowType, usedNames: [])
         present(cashFlowCategoryAlert!.alertController, animated: true)
      }
      
      let addCategoryBTN = UIButton(type: .roundedRect, primaryAction: addCategoryAction)
      addCategoryBTN.setTitle("Add category", for: .normal)
      
      // View Setup
      let stackView = UIStackView(arrangedSubviews: [nameRowStackView, amountRowStackView, datePicker, categoryPicker, categoryValidationLabel, addCategoryBTN])
      stackView.axis = .vertical
      stackView.spacing = 5
      
      view.addSubview(stackView)
      
      // Setup Auto Layout
      stackView.translatesAutoresizingMaskIntoConstraints = false
      categoryPicker.translatesAutoresizingMaskIntoConstraints = false
      
      NSLayoutConstraint.activate([
         stackView.topAnchor.constraint(equalTo: view.topAnchor),
         stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5),
         stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
         stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
         categoryPicker.heightAnchor.constraint(equalToConstant: 110),
      ])
   }
}

// MARK: -- Category Picker Configuration

extension CashFlowAlertVC: UIPickerViewDelegate, UIPickerViewDataSource {

   func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      cashFlowCategories.count
   }
   
   func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
      var label = UILabel()
      if let view = view as? UILabel { label = view }
      label.text = cashFlowCategories[row].name
      label.font = .systemFont(ofSize: 21)
      label.textAlignment = .center

      return label
   }

   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      guard !cashFlowCategories.isEmpty else { return }
      selectedCategory = cashFlowCategories[row]
   }
}

// MARK: -- NSFetchedResultsController Delegate

extension CashFlowAlertVC: NSFetchedResultsControllerDelegate {
   
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      
      switch type {
      case .insert:
         setCategoryPickerVisibility()
         categoryPicker.reloadAllComponents()
      default: break
      }
   }
}

// MARK: -- Helper Functions

extension CashFlowAlertVC {
   
   private func setCategoryPickerVisibility() {
      if cashFlowCategories.isEmpty {
         categoryPicker.isHidden = true
         categoryValidationLabel.isHidden = false
      } else {
         categoryPicker.isHidden = false
         categoryValidationLabel.isHidden = true
         selectedCategory = cashFlowCategories.first
         // TODO: Change behavior when editing.
      }
   }
   
   private func getCashFlowTemplate() -> CashFlowTemplate? {
      CashFlowTemplate(name: nameTextField.text,
                       date: datePicker.date,
                       value: amountTextField.text,
                       wallet: wallet,
                       category: selectedCategory)
   }
   
   func submitAlertAction() {
      guard let template = getCashFlowTemplate() else { return }

      if let cashFlow = cashFlow {
         cashFlow.update(using: template)
      } else {
         CashFlowEntity.create(in: context, using: template)
      }
   }
}

// MARK: -- Validation

extension CashFlowAlertVC {
   
   private var nameValidation: AnyPublisher<Bool, Never> {
      nameTextField.textPublisher()
         .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
         .map { [unowned self] text in
            let result = validationManager.validateName(text, usedNames: [])
            nameValidationLabel.text = result.message

            return result == .isValid
         }
         .eraseToAnyPublisher()
   }
   
   private var amountValidation: AnyPublisher<Bool, Never> {
      amountTextField.textPublisher()
         .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
         .map { [unowned self] text in
            let result = validationManager.validateCurrency(text, canEqualZero: false)
            amountValidationLabel.text = result.message(fieldName: "Amount")
            
            return result == .isValid
         }
         .eraseToAnyPublisher()
   }
}

// MARK: -- Initializers

extension CashFlowAlertVC {
   
   /// CashFlowAlertVC to create new cash-flow.
   convenience init(ofType type: CashFlowType,
                    forWallet wallet: WalletEntity,
                    validationManager: ValidationService = ValidationManager(),
                    in context: NSManagedObjectContext = SceneDelegate.context)
   {
      self.init(cashFlow: nil, type: type, wallet: wallet, validationManager: validationManager, context: context)
   }
   
   /// CashFlowAlertVC for editing existing cash-flow.
   convenience init(editing cashFlow: CashFlowEntity,
                    validationManager: ValidationService = ValidationManager(),
                    in context: NSManagedObjectContext = SceneDelegate.context)
   {
      self.init(cashFlow: cashFlow, type: cashFlow.category.type, wallet: cashFlow.wallet, validationManager: validationManager, context: context)
   }
}
