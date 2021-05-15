//
//  FetchedResultsController.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 11/05/2021.
//

import CoreData
import Foundation

protocol CoreDataEntity: NSManagedObject {
   static var name: String { get }
}

class FetchedResultsController<T>: NSObject, NSFetchedResultsControllerDelegate where T: CoreDataEntity {
   private let context: NSManagedObjectContext
   
   private(set) var fetchedResultsController: NSFetchedResultsController<NSManagedObject>
   
   func delete(_ object: T) {
      context.delete(object)
   }
   
   init(context: NSManagedObjectContext = SceneDelegate.context) {
      self.context = context
      print("Creating FetchedResultsController for \(T.Type.self)")
      let request = NSFetchRequest<T>(entityName: T.name) as! NSFetchRequest<NSManagedObject>
      request.sortDescriptors = []
      request.predicate = nil
      
      fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      
      super.init()
      fetchedResultsController.delegate = self
      performFetch()
   }
   
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      guard let resultController = controller as? NSFetchedResultsController<NSManagedObject> else { return }
      fetchedResultsController = resultController
   }
   
   private func performFetch() {
      do {
         try fetchedResultsController.performFetch()
      } catch let error {
         print("CoreDataFetcher fetching error: \(error)")
      }
   }
}

