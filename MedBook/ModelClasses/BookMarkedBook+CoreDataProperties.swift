//
//  BookMarkedBook+CoreDataProperties.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 16/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//
//

import Foundation
import CoreData


extension BookMarkedBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookMarkedBook> {
        return NSFetchRequest<BookMarkedBook>(entityName: "BookMarkedBook")
    }

    @NSManaged public var title: String?
    @NSManaged public var coverId: String?
    @NSManaged public var ratingsAverage: Float
    @NSManaged public var ratingsCount: Int64
    @NSManaged public var author: [String]?
    @NSManaged public var isBookmarked: Bool

}
