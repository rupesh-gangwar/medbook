//
//  BookCell.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 15/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var ratingsAverage: UILabel!
    @IBOutlet weak var ratingsCount: UILabel!
    @IBOutlet weak var roundrectView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        roundrectView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeCell(book: Book) {
        customize(title: book.title, author: book.authorName, coverId: book.coverId)
    }
    
    func customizeBookmarkCell(book: BookMarkedBook) {
        customize(title: book.title ?? "", author: book.author ?? [], coverId: book.coverId ?? "")
    }
    
    private func customize(title: String, author: [String], coverId: String) {
        bookName.text = title.uppercased()
        authorName.text = author.joined(separator: ",")
        coverImage.loadImageWithUrl(coverId: coverId)
        
        //NO data in API for these 2
        ratingsAverage.text = "0.0"
        ratingsCount.text = "0"
    }
}
