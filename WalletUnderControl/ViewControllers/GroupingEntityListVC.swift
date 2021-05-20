//
//  GroupingEntityListVC.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 11/05/2021.
//

import CoreData
import UIKit

class GroupingEntityListVC<T: GroupingEntity>: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
   
   private let picker: Picker?
   private let context: NSManagedObjectContext
   private let cashFlowType: CashFlowType?
   private let groupingEntities: FetchedResultsController<T>
   private var alert: GroupingEntityAlert<T>? = nil
   
   private let groupungEntityListView = GroupingEntityListView<T>()
   private var tableView: UITableView { groupungEntityListView.tableView }
   
   private init(
      picker: Picker?,
      cashFlowType: CashFlowType?,
      context: NSManagedObjectContext,
      fetchedResultsController: FetchedResultsController<T>
   ) {
      self.picker = picker
      self.context = context
      self.cashFlowType = cashFlowType
      self.groupingEntities = fetchedResultsController
      super.init(nibName: nil, bundle: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tableView.delegate = self
      tableView.dataSource = self
      groupingEntities.fetchedResultsController.delegate = self
      
      let listTitle = cashFlowType?.name(plural: true) ?? "Wallet Types"
      title = picker == nil ? listTitle : "Select Type"
      navigationController?.navigationBar.prefersLargeTitles = true

      let showAlertForCreating = UIAction() { [unowned self] _ in
         showWalletTypeAlert(edit: nil)
      }
      groupungEntityListView.addItemBTN.addAction(showAlertForCreating, for: .touchUpInside)
      
      tableView.frame = view.bounds
      view = groupungEntityListView
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   // MARK: -- User Interactions
   
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         let item = groupingEntities.fetchedResultsController.object(at: indexPath) as! T
         deleteItem(item)
      }
   }
   
   func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
      let item = groupingEntities.fetchedResultsController.object(at: indexPath) as! T
      
      let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
         let deleteBTN = UIAction.delete { [unowned self] in deleteItem(item) }
         let editBTN = UIAction.edit { [unowned self] in showWalletTypeAlert(edit: item) }
         return UIMenu(title: item.name, children: [editBTN, deleteBTN])
      }
      
      return config
   }
   
   // MARK: -- TableView Configuration
   
   func numberOfSections(in tableView: UITableView) -> Int {
      groupingEntities.fetchedResultsController.sections?.count ?? 0
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      let sectionInfo = groupingEntities.fetchedResultsController.sections![section]
      return sectionInfo.numberOfObjects
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "GroupingEntityCell") as! GroupingEntityCell<T>
      let item = groupingEntities.fetchedResultsController.object(at: indexPath) as! T
      cell.configure(with: item, isSelected: picker?.selectedType == item)
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let picker = picker {
         let item = groupingEntities.fetchedResultsController.object(at: indexPath) as! T
         picker.selectRowHandler(item)
         navigationController?.popViewController(animated: true)
      }
      tableView.deselectRow(at: indexPath, animated: true)
   }
   
   // MARK: -- NSFetchedResultsController Delegate
   
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

      switch type {
      case .insert:
         let indexPath = groupingEntities.fetchedResultsController.indexPath(forObject: anObject as! NSManagedObject)!
         tableView.insertRows(at: [indexPath], with: .automatic)
      case .delete:
         tableView.deleteRows(at: [indexPath!], with: .left)
      case .update:
         tableView.reloadData()
      default: break
      }
   }
}

// MARK: -- User Interactions

extension GroupingEntityListVC {

   private func showWalletTypeAlert(edit item: T?) {
      let items = groupingEntities.fetchedResultsController.fetchedObjects as! [T]
      let usedNames = items.map { $0.name }
      
      if T.self == WalletTypeEntity.self {
         alert = GroupingEntityAlert(editing: item as? WalletTypeEntity, usedNames: usedNames)
      } else {
         alert = item != nil
            ? GroupingEntityAlert(editing: item! as! CashFlowCategoryEntity, usedNames: usedNames)
            : GroupingEntityAlert(cashFlowType: cashFlowType!, usedNames: usedNames)
      }
      
      groupungEntityListView.addItemBTN.zoomIn()
      present(alert!.alertController, animated: true)
   }
   
   private func deleteItem(_ item: T) {
      guard item.canBeDeleted() else {
         showOperationNotAllowedAlert(for: item) ; return
      }
      
      context.delete(item)
   }
   
   private func showOperationNotAllowedAlert(for item: T) {
      let title = "Not allowed"
      let msg = "\"\(item.name)\" is currently used."
      
      let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
      alert.addAction(.cancel)
      present(alert, animated: true)
   }
}

// MARK: -- Initializers

extension GroupingEntityListVC {
   
   /// List for Wallet Types
   convenience init(
      picker: Picker? = nil,
      context: NSManagedObjectContext = SceneDelegate.context) where T == WalletTypeEntity
   {
      let sort = WalletTypeEntity.sortByNameASC
      let fetchedResultsController = FetchedResultsController<T>(context: context, sorting: [sort])
      self.init(picker: nil, cashFlowType: nil, context: context, fetchedResultsController: fetchedResultsController)
   }
   
   /// List for CashFlow Categories
   convenience init(
      for cashFlowType: CashFlowType,
      context: NSManagedObjectContext = SceneDelegate.context) where T == CashFlowCategoryEntity
   {
      let predicate = CashFlowCategoryEntity.filterByType(cashFlowType)
      let sort = CashFlowCategoryEntity.sortByNameASC
      let fetchedResultsController = FetchedResultsController<T>(context: context, predicate: predicate, sorting: [sort])
      self.init(picker: nil, cashFlowType: cashFlowType, context: context, fetchedResultsController: fetchedResultsController)
   }
}

// MARK: -- Picker

extension GroupingEntityListVC {
   
   struct Picker {
      let title: String?
      let selectedType: T?
      let selectRowHandler: (_ item: T) -> Void
      
      init(
         title: String? = nil,
         selectedType: T?,
         selectRowHandler: @escaping (_ item: T) -> Void
      ) {
         self.title = title
         self.selectedType = selectedType
         self.selectRowHandler = selectRowHandler
      }
   }
}



