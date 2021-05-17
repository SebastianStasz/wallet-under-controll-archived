//
//  ExchangeRateEntity+CoreDataProperties.swift
//  WalletUnderControl
//
//  Created by Sebastian Staszczyk on 17/05/2021.
//
//

import Foundation
import CoreData


extension ExchangeRateEntity {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ExchangeRateEntity> {
        return NSFetchRequest<ExchangeRateEntity>(entityName: "ExchangeRateEntity")
    }

    @NSManaged public var code: String
    @NSManaged public var rateValue: Double
    @NSManaged public var base: CurrencyEntity

}

extension ExchangeRateEntity : Identifiable {

}
