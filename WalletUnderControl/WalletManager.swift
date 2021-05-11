//
//  WalletManager.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 06/05/2021.
//

import CoreData
import Foundation

protocol WalletService {
   var fetchedResultsController: NSFetchedResultsController<WalletEntity> { get }
   
   func delete(_ wallet: WalletEntity)
}


class WalletManager: NSObject, WalletService {
   static let shared = WalletManager()
   private let context: NSManagedObjectContext
   
   private(set) var fetchedResultsController: NSFetchedResultsController<WalletEntity>
   
   func delete(_ wallet: WalletEntity) {
      context.delete(wallet)
   }
   
   init(context: NSManagedObjectContext = SceneDelegate.context) {
      self.context = context
   
      let request = WalletEntity.createFetchRequest()
      request.sortDescriptors = []
      request.predicate = nil
      
      fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      
      super.init()
      fetchedResultsController.delegate = self
      walletsPerformFetch()
   }
}


extension WalletManager: NSFetchedResultsControllerDelegate {
   
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      guard let walletsResultController = controller as? NSFetchedResultsController<WalletEntity> else { return }
      fetchedResultsController = walletsResultController
   }
   
   private func walletsPerformFetch() {
      do {
         try fetchedResultsController.performFetch()
      } catch let error {
         print("WalletManager fetching error: \(error)")
      }
   }
   
}
