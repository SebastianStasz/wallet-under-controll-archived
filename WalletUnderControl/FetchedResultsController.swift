//
//  FetchedResultsController.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 11/05/2021.
//

import CoreData
import Foundation

class FetchedResultsController<T>: NSObject, NSFetchedResultsControllerDelegate where T: NSManagedObject {
    private let context: NSManagedObjectContext
    
    private(set) var fetchedResultsController: NSFetchedResultsController<NSManagedObject>
    
    func delete(_ object: T) {
        context.delete(object)
    }
    
    init(context: NSManagedObjectContext = SceneDelegate.context,
         predicate: NSPredicate? = nil,
         sorting: [NSSortDescriptor] = [],
         sectionNameKeyPath: String? = nil)
    {
        self.context = context
        //      print("Creating FetchedResultsController for \(T.Type.self)")
        let request = NSFetchRequest<T>(entityName: T.entity().name!) as! NSFetchRequest<NSManagedObject>
        request.sortDescriptors = sorting
        request.predicate = predicate
        request.fetchBatchSize = 20
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        
        super.init()
        fetchedResultsController.delegate = self
        performFetch()
    }
    
    func changePredicate(_ predicate: NSPredicate) {
        fetchedResultsController.fetchRequest.predicate = predicate
        performFetch()
    }
    
    func removePredicate() {
        fetchedResultsController.fetchRequest.predicate = nil
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

