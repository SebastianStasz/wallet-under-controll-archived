//
//  WalletTypeAlert.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 12/05/2021.
//

import Combine
import CoreData
import UIKit

class WalletTypeAlert {
   private var cancellables: Set<AnyCancellable> = []
   
   private let validationManager: ValidationService
   private let context: NSManagedObjectContext
   private let walletType: WalletTypeEntity?
   private let usedNames: [String]
   
   private(set) var alertController: UIAlertController
   
   var textFieldPublisher: AnyPublisher<String, Never> {
      alertController.textFields![0].textPublisher()
   }
    
   init(editing walletType: WalletTypeEntity?,
        validationManager: ValidationService = ValidationManager(),
        context: NSManagedObjectContext = SceneDelegate.context,
        usedNames: [String]
   ) {
      self.context = context
      self.usedNames = usedNames
      self.walletType = walletType
      self.validationManager = validationManager
      alertController = UIAlertController(title: "Create Wallet Type", message: nil, preferredStyle: .alert)
      setupAlertController()
   }
}

// MARK: -- Setup Alert Controller

extension WalletTypeAlert {
   private func setupAlertController() {
      
      alertController.addTextField()
      var submitBtnTitle = "Add"
      
      if let walletType = walletType {
         alertController.title = "Edit \"\(walletType.name)\""
         alertController.textFields![0].text = walletType.name
         submitBtnTitle = "Update"
      }
      
      // MARK: -- Setup Controller Actions
      
      let submitAction = UIAlertAction(title: submitBtnTitle, style: .default) { [unowned self] _ in
         guard var name = alertController.textFields![0].text, !name.isEmpty else { return }
         name = name.trimmingCharacters(in: .whitespacesAndNewlines)
         
         if let typeToEdit = walletType {
            typeToEdit.update(name: name)
         } else {
            WalletTypeEntity.create(in: context, name: name)
         }
      }
      
      submitAction.isEnabled = false
      
      alertController.addAction(submitAction)
      alertController.addAction(UIAlertAction.cancelAction)
      
      // MARK: -- Wallet Type Name Validation
      
      textFieldPublisher
         .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
         .map { [unowned self] text in
            validationManager.validateName(text, usedNames: usedNames)
         }
         .sink { [unowned self] name in
            submitAction.isEnabled = name == .isValid ? true : false
            alertController.message = name.message
         }
         .store(in: &cancellables)
   }
}



