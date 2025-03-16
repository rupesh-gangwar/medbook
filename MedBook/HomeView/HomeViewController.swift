//
//  HomeViewController.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 14/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import UIKit

enum SortBy {
    case title
    case average
    case hits
}

final class HomeViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortView: UIView!
    
    private var booksArray: [Book]?

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeUI()
        displayView(display: true)
    }
    
    private func customizeUI() {
        let nib = UINib(nibName: "BookCell", bundle: nil)
        self.tableView?.register(nib, forCellReuseIdentifier: "BookCelldentifier")
    }
    
    private func displayView(display: Bool) {
        self.tableView.isHidden = display
        self.sortView.isHidden = display
    }

    @IBAction func logoutClicked(sender: UIButton) {
        UserDefaultsHelper.userLoggedOut()
        if let navVC = self.navigationController as? MainNavigationController {
            navVC.showLaunchScreen()
        }
    }
    
    @IBAction func sortBookList(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            print("Sort using title, already sort by default")
        case 102:
            print("Sort using average, but not in API response")
        case 103:
            print("Sort using hits, but not in API response")
        default:
            print("")
        }
        
        for tag in 101..<104 {
            if let button = self.view.viewWithTag(tag) {
                if sender.tag == tag {
                    button.backgroundColor = UIColor.lightGray
                } else {
                    button.backgroundColor = UIColor.white
                }
            }
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.count > 2 {
            searchBar.resignFirstResponder()
            view.showLoader()
            APIManager.shared.fetchBooksList(text: searchText, limit: 10, offset: 0) { books in
                //print(books)
                self.booksArray = self.sortedResponse(by: .title, array: books)
                DispatchQueue.main.async {
                    self.view.dismissLoader()
                    self.displayView(display: false)
                    self.tableView.reloadData()
                }
            }
        } else {
            self.booksArray?.removeAll()
            DispatchQueue.main.async {
                self.displayView(display: true)
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(text)
        return true
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCelldentifier", for: indexPath) as? BookCell
        if let book = booksArray?[indexPath.row] {
            cell?.customizeCell(book: book)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = UIContextualAction(style: .destructive, title: nil) {  (contextualAction, view, boolValue) in
            self.booksArray?[indexPath.row].isBookmarked.toggle()
            if self.booksArray?[indexPath.row].isBookmarked ?? false {
                // save into core data
                DataBaseManager.shared.saveBookmaredBook(book: self.booksArray?[indexPath.row])
            } else {
                // remove from core data
                DataBaseManager.shared.deleteBook(book: self.booksArray?[indexPath.row])
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        let bookmarked = self.booksArray?[indexPath.row].isBookmarked
        item.image = UIImage(systemName: bookmarked ?? false ?  "bookmark.fill" : "bookmark")
        item.backgroundColor = UIColor.green

        let swipeActions = UISwipeActionsConfiguration(actions: [item])
    
        return swipeActions
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //If we reach the end of the table.
        
        if (scrollView.contentOffset.y + scrollView.frame.size.height + 1) >= scrollView.contentSize.height
        {
            // Call method
            print("We are at battom of screen")
            let searchText = searchBar.text ?? ""
            self.view.showLoader()
            APIManager.shared.fetchBooksList(text: searchText, limit: 10, offset: booksArray?.count ?? 0) { (books) in
                self.booksArray?.append(contentsOf: books)
                self.booksArray = self.sortedResponse(by: .title, array: self.booksArray ?? [])
                DispatchQueue.main.async {
                    self.view.dismissLoader()
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension HomeViewController {
    private func sortedResponse(by: SortBy, array: [Book]) -> [Book] {
        var newArray = [Book]()
        switch by {
        case .title:
            newArray = array.sorted(by: {
                $0.title < $1.title
            })
        case .average:
            print("Key is not available in API response")
        case .hits:
            print("Key is not available in API response")
        }
        
        return newArray
    }
}
