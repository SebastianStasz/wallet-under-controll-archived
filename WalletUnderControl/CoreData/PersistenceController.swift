//
//  PersistenceController.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 07/05/2021.
//

import Combine
import CoreData

class PersistenceController {
   static let shared = PersistenceController()
   private var cancellables: Set<AnyCancellable> = []
   
   private let container: NSPersistentContainer
   let context: NSManagedObjectContext
   
   init(inMemory: Bool = false) {
      container = NSPersistentContainer(name: "WalletUnderControl")
      
      if inMemory {
         container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
      }
      
      container.loadPersistentStores { storeDescription, error in
         guard let error = error else { return }
         fatalError("Loading persistent stores error: \(error)")
      }
      
      context = container.viewContext
      saveContextPublisher()
   }
   
   private func save() {
      do {
         try context.save()
         print("Saving Context")
      }
      catch let error {
         // TODO: Temporary Fatal Error
         fatalError("Saving context error: \(error)")
      }
   }
   
   private func saveContextPublisher() {
      NotificationCenter.default
         .publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
         .debounce(for: .seconds(5), scheduler: DispatchQueue.main)
         .sink { [weak self] notification in self?.save() }
         .store(in: &cancellables)
   }
}

// MARK: -- Preview

extension PersistenceController {
   
   static var preview: PersistenceController = {
      let result = PersistenceController.init(inMemory: true)
      let viewContext = result.context
      
      _ = WalletEntity.createWallets(context: viewContext)
//      _ = CashFlowCategoryEntity.createCashFlowCategories(context: viewContext)
      
      do {
         try viewContext.save()
      } catch let error {
         fatalError("CoreData preview saving error: \(error)")
      }
      
      return result
   }()
   
   static var empty: PersistenceController = {
      let result = PersistenceController.init(inMemory: true)
      let viewContext = result.context
      
      do {
         try viewContext.save()
      } catch let error {
         fatalError("CoreData preview saving error: \(error)")
      }
      
      return result
   }()
}
