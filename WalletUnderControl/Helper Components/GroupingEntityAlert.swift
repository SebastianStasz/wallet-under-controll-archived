//
//  GroupingEntityAlert.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 12/05/2021.
//

import Combine
import CoreData
import UIKit

class GroupingEntityAlert<T: GroupingEntity> {
   private var cancellables: Set<AnyCancellable> = []
   
   private let validationManager: ValidationService
   private let context: NSManagedObjectContext
   private let cashFlowType: CashFlowType?
   private let usedNames: [String]
   private let groupingItem: T?
   
   private(set) var alertController: UIAlertController
   
   var textFieldPublisher: AnyPublisher<String, Never> {
      alertController.textFields![0].textPublisher()
   }
    
   private init(editing groupingItem: T?,
        cashFlowType: CashFlowType?,
        validationManager: ValidationService = ValidationManager(),
        context: NSManagedObjectContext = SceneDelegate.context,
        usedNames: [String]
   ) {
      self.context = context
      self.usedNames = usedNames
      self.groupingItem = groupingItem
      self.cashFlowType = cashFlowType
      self.validationManager = validationManager
      
      let action = groupingItem == nil ? "Create" : "Edit"
      let title = cashFlowType == nil ? "Wallet Type" : "\(cashFlowType!.name()) Category"
      
      alertController = UIAlertController(title: "\(action) \(title)", message: nil, preferredStyle: .alert)
      setupAlertController()
   }
}

// MARK: -- Setup Alert Controller

extension GroupingEntityAlert {
   private func setupAlertController() {
      
      alertController.addTextField()
      var submitBtnTitle = "Add"
      
      if let groupingItem = groupingItem {
         alertController.title = "Edit \"\(groupingItem.name)\""
         alertController.textFields![0].text = groupingItem.name
         submitBtnTitle = "Update"
      }
      
      // MARK: -- Setup Controller Actions
      
      let submitAction = UIAlertAction(title: submitBtnTitle, style: .default) { [unowned self] _ in
         guard var name = alertController.textFields![0].text, !name.isEmpty else { return }
         name = name.trimmingCharacters(in: .whitespacesAndNewlines)
         
         if let groupingItem = groupingItem {
            groupingItem.update(name: name)
         } else {
            if let cashFlowType = cashFlowType {
               CashFlowCategoryEntity.create(in: context, name: name, type: cashFlowType)
            } else {
               WalletTypeEntity.create(in: context, name: name)
            }
         }
      }
      
      submitAction.isEnabled = false
      
      alertController.addAction(submitAction)
      alertController.addAction(UIAlertAction.cancel)
      
      // MARK: -- Wallet Type Name Validation
      
      textFieldPublisher
         .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
         .map { [unowned self] text in
            validationManager.validateName(text, usedNames: usedNames)
         }
         .sink { [unowned self] name in
            submitAction.isEnabled = name == .isValid 
            alertController.message = name.message
         }
         .store(in: &cancellables)
   }
}

// MARK: -- Initializers

extension GroupingEntityAlert {
   
   // Allert for creating and editing Wallet Type.
   convenience init(editing walletType: WalletTypeEntity?,
                    validationManager: ValidationService = ValidationManager(),
                    context: NSManagedObjectContext = SceneDelegate.context,
                    usedNames: [String])
   {
      self.init(editing: walletType as? T, cashFlowType: nil, validationManager: validationManager, context: context, usedNames: usedNames)
   }
   
   // Allert for creating Cash Flow Category.
   convenience init(cashFlowType: CashFlowType,
                    validationManager: ValidationService = ValidationManager(),
                    context: NSManagedObjectContext = SceneDelegate.context,
                    usedNames: [String])
   {
      self.init(editing: nil, cashFlowType: cashFlowType, validationManager: validationManager, context: context, usedNames: usedNames)
   }
   
   // Allert for editing Cash Flow Category.
   convenience init(editing cashFlowCategory: CashFlowCategoryEntity,
                    validationManager: ValidationService = ValidationManager(),
                    context: NSManagedObjectContext = SceneDelegate.context,
                    usedNames: [String])
   {
      self.init(editing: cashFlowCategory as? T, cashFlowType: cashFlowCategory.type, validationManager: validationManager, context: context, usedNames: usedNames)
   }
}



