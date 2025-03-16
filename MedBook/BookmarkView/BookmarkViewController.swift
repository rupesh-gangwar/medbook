//
//  BookmarkViewController.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 14/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import UIKit

final class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var bookmarkedArray: [BookMarkedBook]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizeUI()
        fetchBookmarkedData()
    }
    
    private func customizeUI() {
        let nib = UINib(nibName: "BookCell", bundle: nil)
        self.tableView?.register(nib, forCellReuseIdentifier: "BookCelldentifier")
    }
    
    private func fetchBookmarkedData() {
        bookmarkedArray = DataBaseManager.shared.fetchBookmarkedData()
        if bookmarkedArray?.isEmpty ?? true {
            showOneButtonAlert(title: "Alert", message: "No bookmarked data")
        }
    }
    
    @IBAction func backClicked(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCelldentifier", for: indexPath) as? BookCell
        if let book = bookmarkedArray?[indexPath.row] {
            cell?.customizeBookmarkCell(book: book)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .destructive, title: nil) {  (contextualAction, view, boolValue) in
            DataBaseManager.shared.deleteBookmaredBook(book: self.bookmarkedArray?[indexPath.row])
            self.bookmarkedArray?.remove(at: indexPath.row)
            tableView.reloadData()
        }
        item.image = UIImage(systemName: "bookmark.fill")
        item.backgroundColor = UIColor.green

        let swipeActions = UISwipeActionsConfiguration(actions: [item])
    
        return swipeActions
    }
}
