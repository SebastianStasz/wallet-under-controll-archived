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
   
   // Settings
   private let minLength = 3
   private let maxLength = 15
   private let delayInSeconds = 0.3
   
   private var cancellables: Set<AnyCancellable> = []
   
   private let usedNames: [String]
   private let context: NSManagedObjectContext
   private let walletType: WalletTypeEntity?
   
   private(set) var alertController: UIAlertController
   
   var textFieldPublisher: AnyPublisher<String, Never> {
      alertController.textFields![0].textPublisher()
   }
    
   init(editing walletType: WalletTypeEntity?,
        context: NSManagedObjectContext = SceneDelegate.context,
        usedNames: [String]
   ) {
      self.context = context
      self.walletType = walletType
      self.usedNames = usedNames
      alertController = UIAlertController(title: "Create Wallet Type", message: nil, preferredStyle: .alert)
      setupAlertController()
   }

   private func setupAlertController() {
      alertController.addTextField()
      var submitBtnTitle = "Add"
      
      if let walletType = walletType {
         alertController.title = "Edit \"\(walletType.name)\""
         alertController.textFields![0].text = walletType.name
         submitBtnTitle = "Update"
      }
      
      let submitAction = UIAlertAction(title: submitBtnTitle, style: .default) { [unowned self] _ in
         guard var name = alertController.textFields![0].text, !name.isEmpty else { return }
         name = name.trimmingCharacters(in: .whitespacesAndNewlines)
         
         if let typeToEdit = walletType {
            typeToEdit.name = name
         } else {
            WalletTypeEntity.create(in: context, name: name)
         }
      }
      
      submitAction.isEnabled = false
      
      alertController.addAction(submitAction)
      alertController.addAction(UIAlertAction.cancelAction)
      
      isNameValid
         .sink { [unowned self] name in
            submitAction.isEnabled = name == .isValid ? true : false
            alertController.message = name.message
         }
         .store(in: &cancellables)
   }
}

// MARK: -- Wallet Type Name Validation

extension WalletTypeAlert {
   
   private var isNameValid: AnyPublisher<NameValidation, Never> {
      textFieldPublisher
         .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
         .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
         .map { [unowned self] text in
            if text.isEmpty { return .isEmpty }
            if text.replacingOccurrences(of: " ", with: "").count < minLength { return .tooShort }
            if text.count >= maxLength { return .tooLong}
            if usedNames.contains(text) { return .notUnique }
            return .isValid
         }
         .eraseToAnyPublisher()
   }
   
   enum NameValidation {
      case notUnique
      case tooShort
      case tooLong
      case isEmpty
      case isValid
      
      var message: String? {
         switch self {
         case .notUnique:
            return "Type with that name already exist."
            
         case .tooShort:
            return "Name must have at least 3 characters."
            
         case .tooLong:
            return "Name is too long. Max 15 characters."
            
         case .isEmpty:
            return "Name can not be empty."
            
         case .isValid: return nil
         }
      }
   }
}
