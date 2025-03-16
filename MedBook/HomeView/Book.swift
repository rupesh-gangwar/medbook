//
//  Book.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 14/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import Foundation

struct Book {
    var title: String
    var authorName: [String]
    var coverId: String
    var ratingsAverage: Float
    var ratingsCount: Int
    var isBookmarked: Bool = false
}
