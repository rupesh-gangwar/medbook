//
//  MedBookUser+CoreDataProperties.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 15/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//
//

import Foundation
import CoreData


extension MedBookUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedBookUser> {
        return NSFetchRequest<MedBookUser>(entityName: "MedBookUser")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var country: String?

}
