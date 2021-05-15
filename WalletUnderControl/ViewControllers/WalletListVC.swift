//
//  WalletListVC.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 06/05/2021.
//

import CoreData
import UIKit

class WalletListVC: UIViewController {
   private let wallets: FetchedResultsController<WalletEntity>
   private let walletsTBV = UITableView()
   
   init(wallets: FetchedResultsController<WalletEntity> = WalletEntity.fetchedResultsController()) {
      self.wallets = wallets
      super.init(nibName: nil, bundle: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()

      walletsTBV.delegate = self
      walletsTBV.dataSource = self
      wallets.fetchedResultsController.delegate = self
      
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
      let wallet = wallets.fetchedResultsController.object(at: indexPath) as! WalletEntity
      
      let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
         let deleteBTN = UIAction.deleteAction { [unowned self] in showDeletingAlertForWallet(wallet) }
         let editBTN = UIAction.editAction { [unowned self] in showActionWalletSheet(for: wallet) }
         return UIMenu(title: wallet.name, children: [editBTN, deleteBTN])
      }
      
      return config
   }
   
   private func showDeletingAlertForWallet(_ wallet: WalletEntity) {
      let title = "Delete \"\(wallet.name)\""
      let message = "All data will be deleted!"
      
      let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
      ac.addAction(UIAlertAction.deleteAction { [unowned self] in wallets.delete(wallet) })
      ac.addAction(UIAlertAction.cancelAction)
      
      present(ac, animated: true)
   }
   
   @objc private func showCreatingWalletSheet() {
      showActionWalletSheet(for: nil)
   }
   
   private func showActionWalletSheet(for wallet: WalletEntity?) {
      let walletFormVC = WalletFormVC(wallet: wallet, wallets: wallets)
      let walletFormNC = UINavigationController(rootViewController: walletFormVC)
      present(walletFormNC, animated: true)
   }
}

// MARK: -- TableView Configuration

extension WalletListVC: UITableViewDelegate, UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      wallets.fetchedResultsController.sections?.count ?? 0
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      let sectionInfo = wallets.fetchedResultsController.sections![section]
      return sectionInfo.numberOfObjects
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: WalletCell.id) as! WalletCell
      let wallet = wallets.fetchedResultsController.object(at: indexPath) as! WalletEntity
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
      case .update:
         let indexPath = controller.indexPath(forObject: anObject as! NSManagedObject)
         walletsTBV.reloadRows(at: [indexPath!], with: .automatic)
      case .insert:
         let indexPath = controller.indexPath(forObject: anObject as! NSManagedObject)
         walletsTBV.insertRows(at: [indexPath!], with: .automatic)
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
