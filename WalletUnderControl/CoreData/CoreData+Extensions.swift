//
//  CoreData+Extensions.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 19/05/2021.
//

import CoreData
import Foundation

extension NSManagedObject {
   
   static func fetchedResultsController<T: NSManagedObject> (
      in context: NSManagedObjectContext = SceneDelegate.context,
      predicate: NSPredicate? = nil,
      sorting: [NSSortDescriptor] = []) -> FetchedResultsController<T>
   {
      FetchedResultsController<T>(context: context, predicate: predicate, sorting: sorting)
   }
}
