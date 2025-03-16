//
//  UserDefaultsHelper.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 16/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import Foundation

final class UserDefaultsHelper {
    
    // Session for log in
    class func userLoggedIn() {
        UserDefaults.standard.set(true, forKey: "UserLoggedIn")
    }
    
    class func userLoggedOut() {
        UserDefaults.standard.set(false, forKey: "UserLoggedIn")
    }
    
    class func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "UserLoggedIn")
    }
    
    // Default Country
    class func setDefaultCountry(country: [String: String]) {
        UserDefaults.standard.set(country, forKey: "DefaultCountry")
    }
    
    class func getDefaultCountry() -> [String: String]? {
        return UserDefaults.standard.object(forKey: "DefaultCountry") as? [String : String]
    }
}
