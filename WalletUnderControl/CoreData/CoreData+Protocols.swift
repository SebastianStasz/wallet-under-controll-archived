//
//  CoreData+Protocols.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 19/05/2021.
//

import CoreData
import Foundation

protocol GroupingEntity: NSManagedObject {
   var name: String { get }
   func update(name: String) -> Void
}
