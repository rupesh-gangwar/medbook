//
//  APIManager.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 14/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import Foundation

final class APIManager {
    
    static let shared = APIManager()
    private init() {
        // initialized
    }
    let session = URLSession.shared
    
    func fetchDefaultCountry() {
        
        // check if default country already exist
        let country = UserDefaultsHelper.getDefaultCountry()
        if country?.keys.count ?? 0 > 0 {
            // don't call API
            return
        }
        
        // If default country is empty, call API
        let url = URL(string: "http://ip-api.com/json")!
        let task = session.dataTask(with: url) { data, response, error in
            // Handle the data task response
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                //print("Received default country data: \(data)")
                let parsedData = APIManager.shared.parseJSONData(data: data)
                var defaultCountry = [String: String]()
                defaultCountry["name"] = parsedData?["country"] as? String
                defaultCountry["code"] = parsedData?["countryCode"] as? String
                
                UserDefaultsHelper.setDefaultCountry(country: defaultCountry)
            }
        }

        // Resume the data task
        task.resume()
    }
    
    func fetchCountryList(completion: @escaping (Bool) -> ()) {
        
        // check if country list already exists
        let list = DataBaseManager.shared.countryList()
        if list.count > 0 {
            // don't call API
            completion(true)
            return
        }
        
        //If list is empty, Call list API
        var components = URLComponents(string: "https://api.first.org/data/v1/countries")!
        components.queryItems = [
            URLQueryItem(name: "limit", value: "300")
        ]
        guard let url = components.url else {
            // error
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            // Handle the data task response
            if let error = error {
                print("Error: \(error)")
                completion(false)
            } else if let data = data {
                //print("Received country data: \(data)")
                let parsedData = APIManager.shared.parseJSONData(data: data)
                if let countries = parsedData?["data"] as? [String: AnyObject] {
                    DataBaseManager.shared.saveCountryList(countryList: countries)
                    completion(true)
                }
            }
        }

        // Resume the data task
        task.resume()
    }
    
    func fetchBooksList(text: String, limit: Int, offset: Int, completion: @escaping ([Book]) -> ()) {
        
        let queryItems = [URLQueryItem(name: "title", value: text), URLQueryItem(name: "limit", value: String(limit)), URLQueryItem(name: "offset", value: String(offset))]
        var urlComps = URLComponents(string: "https://openlibrary.org/search.json")!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        
        let task = session.dataTask(with: url) { data, response, error in
            // Handle the data task response
            if let error = error {
                print("Error: \(error)")
                completion([])
            } else if let data = data {
                // Process the data further
                let parsedData = APIManager.shared.parseJSONData(data: data)
                //print("Received parsedData: \(parsedData)")
                if let books = parsedData?["docs"] as? [[String: AnyObject]] {
                    var booksArray = [Book]()
                    for dictionary in books {
                        var coverStr = ""
                        if let coverId = dictionary["cover_i"] as? Int {
                            coverStr = String(describing: coverId)
                        }
                        let book = Book(title: dictionary["title"] as? String ?? "",
                                          authorName: dictionary["author_name"] as? [String] ?? [],
                                          coverId: coverStr,
                                          ratingsAverage: 0,
                                          ratingsCount: 0)
                        booksArray.append(book)
                    }
                    completion(booksArray)
                }
            }
        }

        // Resume the data task
        task.resume()
    }
    
    func downloadCoverImage(url: URL, completion:  @escaping (Result<Data, Error>) -> ()) {
        let task = session.dataTask(with: url) { data, response, error in
            // Handle the data task response
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
            } else if let data = data {
                print("Received cover image data: \(data)")
                // Process the data further
                completion(.success(data))
            }
        }

        // Resume the data task
        task.resume()
    }
    
    private func parseJSONData(data: Data) -> [String: AnyObject]? {
        do {
            let parsedData = try JSONSerialization.jsonObject(with: data) as! [String: AnyObject]
            return parsedData
          
        } catch let error as NSError {
          print(error)
        }
        
        return nil
    }
    
}
