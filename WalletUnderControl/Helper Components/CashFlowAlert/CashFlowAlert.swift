//
//  CashFlowAlert.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 18/05/2021.
//

import Combine
import UIKit

class CashFlowAlert {
   private var cancellables: Set<AnyCancellable> = []
   private let cashFlowAlertVC: CashFlowAlertVC
   
   let alert: UIAlertController
   
   init(cashFlowAlertVC: CashFlowAlertVC) {
      self.cashFlowAlertVC = cashFlowAlertVC
      alert = UIAlertController(title: cashFlowAlertVC.alertTitle, message: nil, preferredStyle: .alert)
      setupAlertController()
   }
}

// MARK: -- Alert Setup

extension CashFlowAlert {
   
   private func setupAlertController() {
      alert.setValue(cashFlowAlertVC, forKey: "contentViewController")
      
      let addBTN = UIAlertAction(title: cashFlowAlertVC.submitBTNTitle, style: .default) { [unowned self] _ in
         cashFlowAlertVC.submitAlertAction()
      }
      
      addBTN.isEnabled = false
      alert.addAction(addBTN)
      alert.addAction(UIAlertAction.cancel)
      
      cashFlowAlertVC.$isValid
         .sink { addBTN.isEnabled = $0 }
         .store(in: &cancellables)
   }
}
