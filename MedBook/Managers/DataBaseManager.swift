//
//  DataBaseManager.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 14/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import Foundation
import CoreData

final class DataBaseManager {
    static let shared = DataBaseManager()
    private init() {
        //initailized
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MedBook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension DataBaseManager {
    func countryList() -> [String] {
        let context = DataBaseManager.shared.persistentContainer.viewContext
        var countryData: [Country] = []
        //let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Country.self))
        let request = NSFetchRequest<Country>(entityName: "Country")
        do {
            countryData = try context.fetch(request)
        } catch  {
            print(error)
        }
        
        var list: [String] = []
        if countryData.count > 0 {
            list = countryData.map { ("\(String($0.name ?? ""))")}
        }
        
        return list
    }
    
    func saveCountryList(countryList: [String: AnyObject]) {
        let context = DataBaseManager.shared.persistentContainer.viewContext
        for (key, value) in countryList {
            
            if let countryDetail = value as? [String: String] {
                                
                let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: Country.self), into: context) as? Country
                if entity != nil {
                    entity?.name = countryDetail["country"]
                    entity?.code = countryDetail["region"]
                    entity?.region = key
                }
            }
        }
        
        do {
            let _ = try context.save()
        } catch  {
            print(error)
        }
    }
    
    func saveUserForSignUp(mail: String, password: String, country: String) -> Bool {
        if !checkForDuplicate(email: mail) {
            let context = DataBaseManager.shared.persistentContainer.viewContext
            let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: MedBookUser.self), into: context) as? MedBookUser
            if entity != nil {
                entity?.email = mail
                entity?.password = password
                entity?.country = country
            }
            
            do {
                let _ = try context.save()
            } catch  {
                print(error)
            }
            return true
        } else {
            return false
        }
    }
    
    func saveBookmaredBook(book: Book?) {
        let context = DataBaseManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: BookMarkedBook.self), into: context) as? BookMarkedBook
        if entity != nil {
            entity?.title = book?.title
            entity?.author = book?.authorName
            entity?.coverId = book?.coverId
            entity?.ratingsAverage = 0.0
            entity?.ratingsCount = 0
        }
        
        do {
            let _ = try context.save()
        } catch  {
            print(error)
        }
    }
    
    func deleteBook(book: Book?) {
        deleteBookFromDB(title: book?.title ?? "", author: book?.authorName ?? [])
    }
    
    func deleteBookmaredBook(book: BookMarkedBook?) {
        deleteBookFromDB(title: book?.title ?? "", author: book?.author ?? [])
    }
    
    private func deleteBookFromDB(title: String, author: [String]) {
        let context = DataBaseManager.shared.persistentContainer.viewContext
        let request = NSFetchRequest<BookMarkedBook>(entityName: "BookMarkedBook")
        request.predicate = NSPredicate(format: "title = %@ AND author = %@", title, author)
        do {
            let result = try context.fetch(request)
            for data in result
            {
               context.delete(data)
            }
            try context.save()
            
        } catch  {
            print(error)
        }
    }
    
    
    private func checkForDuplicate(email: String) -> Bool {
        let context = DataBaseManager.shared.persistentContainer.viewContext
        var userData: [MedBookUser] = []
        let request = NSFetchRequest<MedBookUser>(entityName: "MedBookUser")
        do {
            userData = try context.fetch(request)
        } catch  {
            print(error)
        }
        
        for user in userData {
            if user.email == email {
                return true
            }
        }
        
        return false
    }
}

extension DataBaseManager {
    
    func verifyUserCredentials(email: String, password: String) -> Bool {
        
        let context = DataBaseManager.shared.persistentContainer.viewContext
        var userData: [MedBookUser] = []
        let request = NSFetchRequest<MedBookUser>(entityName: "MedBookUser")
        do {
            userData = try context.fetch(request)
        } catch  {
            print(error)
        }
        
        for savedUser in userData {
            if savedUser.email == email && savedUser.password == password {
                return true
            }
        }
        
        return false
    }
    
    func fetchBookmarkedData() -> [BookMarkedBook] {
        let context = DataBaseManager.shared.persistentContainer.viewContext
        var bookData: [BookMarkedBook] = []
        let request = NSFetchRequest<BookMarkedBook>(entityName: "BookMarkedBook")
        do {
            bookData = try context.fetch(request)
        } catch  {
            print(error)
        }
        
        return bookData
    }
}
