//
//  Country+CoreDataProperties.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 15/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var region: String?

}
