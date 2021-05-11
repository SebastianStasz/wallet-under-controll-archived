//
//  WalletListVC.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 06/05/2021.
//

import CoreData
import UIKit

class WalletListVC: UIViewController {
   private let walletsManager: WalletService
   private let walletsTBV = UITableView()
   
   init(walletsManager: WalletService = WalletManager.shared) {
      self.walletsManager = walletsManager
      super.init(nibName: nil, bundle: nil)
      
      walletsTBV.delegate = self
      walletsTBV.dataSource = self
      walletsManager.fetchedResultsController.delegate = self
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()

      walletsTBV.rowHeight = WalletCell.height
      walletsTBV.register(WalletCell.self, forCellReuseIdentifier: WalletCell.id)

      view = walletsTBV
      setupNavigation()
   }
   
   private func setupNavigation() {
      let addWalletBTN = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCreatingWalletSheet))
      
      title = "Wallets"
      navigationItem.rightBarButtonItem = addWalletBTN
      navigationController?.navigationBar.prefersLargeTitles = true
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

// MARK: -- User Interactions

extension WalletListVC {
   
   func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
      let wallet = walletsManager.fetchedResultsController.object(at: indexPath)
      
      let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
         let deleteBTN = UIAction.deleteAction { [unowned self] in showDeletingAlertForWallet(wallet) }
         let editBTN = UIAction.editAction { [unowned self] in showCreatingWalletSheet() }
         return UIMenu(title: wallet.name, children: [editBTN, deleteBTN])
      }
      
      return config
   }
   
   private func showDeletingAlertForWallet(_ wallet: WalletEntity) {
      let title = "Delete \"\(wallet.name)\""
      let message = "All data will be deleted!"
      
      let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
      ac.addAction(UIAlertAction.deleteAction { [unowned self] in walletsManager.delete(wallet) })
      ac.addAction(UIAlertAction.cancelAction)
      
      present(ac, animated: true)
   }
   
   @objc private func showCreatingWalletSheet() {
      
   }
}

// MARK: -- TableView Configuration

extension WalletListVC: UITableViewDelegate, UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      walletsManager.fetchedResultsController.sections?.count ?? 0
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      let sectionInfo = walletsManager.fetchedResultsController.sections![section]
      return sectionInfo.numberOfObjects
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: WalletCell.id) as! WalletCell
      let wallet = walletsManager.fetchedResultsController.object(at: indexPath)
      cell.configure(wallet: wallet)
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
   }
}

// MARK: -- NSFetchedResultsController Delegate

extension WalletListVC: NSFetchedResultsControllerDelegate {
   
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
      
      switch type {
      case .delete: walletsTBV.deleteRows(at: [indexPath!], with: .left)
      default: break
      }
   }
}

// Delete on move gesture
//   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//      if editingStyle == .delete {
//         let wallet = walletsManager.fetchedResultsController.object(at: indexPath)
//         showDeletingAlertForWallet(wallet)
//      }
//   }
