//
//  WalletTypeListVC.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 11/05/2021.
//

import CoreData
import UIKit

class WalletTypeListVC: UIViewController {
   private let walletTypes: FetchedResultsController<WalletTypeEntity>
   private let context: NSManagedObjectContext
   private var walletTypeAlert: WalletTypeAlert? = nil
   
   private let walletTypeListView = WalletTypeListView()
   private var walletTypesTBV: UITableView { walletTypeListView.walletTypesTBV }
   
   init(walletTypes: FetchedResultsController<WalletTypeEntity> = WalletTypeEntity.fetchedResultsController, context: NSManagedObjectContext = SceneDelegate.context) {
      self.walletTypes = walletTypes
      self.context = context
      super.init(nibName: nil, bundle: nil)
      
      walletTypesTBV.delegate = self
      walletTypesTBV.dataSource = self
      walletTypes.fetchedResultsController.delegate = self
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      title = "Wallet Types"
      navigationController?.navigationBar.prefersLargeTitles = true

      walletTypeListView.addTypeBTN.addTarget(self, action: #selector(showCreatingWalletTypeAlert), for: .touchUpInside)
      
      walletTypesTBV.frame = view.bounds
      view = walletTypeListView
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

// MARK: -- User Interactions

extension WalletTypeListVC {
   
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         let walletType = walletTypes.fetchedResultsController.object(at: indexPath) as! WalletTypeEntity
         deleteWalletType(walletType)
      }
   }
   
   func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
      let walletType = walletTypes.fetchedResultsController.object(at: indexPath) as! WalletTypeEntity
      
      let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
         let deleteBTN = UIAction.deleteAction { [unowned self] in deleteWalletType(walletType) }
         let editBTN = UIAction.editAction { [unowned self] in showWalletTypeAlert(edit: walletType) }
         return UIMenu(title: walletType.name, children: [editBTN, deleteBTN])
      }
      
      return config
   }
   
   @objc private func showCreatingWalletTypeAlert() {
      showWalletTypeAlert(edit: nil)
   }
   
   private func showWalletTypeAlert(edit walletType: WalletTypeEntity?) {
      let walletTypes = walletTypes.fetchedResultsController.fetchedObjects as! [WalletTypeEntity]
      let usedNames = walletTypes.map { $0.name }
      walletTypeAlert = WalletTypeAlert(editing: walletType, usedNames: usedNames)
      walletTypeListView.addTypeBTN.zoomIn()

      present(walletTypeAlert!.alertController, animated: true)
   }
   
   // ---------------
   
   private func deleteWalletType(_ walletType: WalletTypeEntity) {
      guard walletType.wallets.isEmpty else {
         showOperationNotAllowedAlert(for: walletType)
         return
      }
      
      walletTypes.delete(walletType)
   }
   
   private func showOperationNotAllowedAlert(for walletType: WalletTypeEntity) {
      let alert = UIAlertController(title: "Not allowed", message: "\"\(walletType.name)\" is currently used.", preferredStyle: .alert)
      alert.addAction(.cancelAction)
      present(alert, animated: true)
   }
}

// MARK: -- TableView Configuration

extension WalletTypeListVC: UITableViewDelegate, UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      walletTypes.fetchedResultsController.sections?.count ?? 0
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      let sectionInfo = walletTypes.fetchedResultsController.sections![section]
      return sectionInfo.numberOfObjects
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: WalletTypeCell.id) as! WalletTypeCell
      let walletType = walletTypes.fetchedResultsController.object(at: indexPath) as! WalletTypeEntity
      cell.configure(with: walletType)
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
   }
}

// MARK: -- NSFetchedResultsController Delegate

extension WalletTypeListVC: NSFetchedResultsControllerDelegate {
   
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

      switch type {
      case .insert:
         let indexPath = walletTypes.fetchedResultsController.indexPath(forObject: anObject as! NSManagedObject)!
         walletTypesTBV.insertRows(at: [indexPath], with: .automatic)
      case .delete:
         walletTypesTBV.deleteRows(at: [indexPath!], with: .left)
      case .update:
         walletTypesTBV.reloadData()
      default: break
      }
   }
}



