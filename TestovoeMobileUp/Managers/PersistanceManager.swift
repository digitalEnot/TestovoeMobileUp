//
//  PersistanceManager.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 09.08.2024.
//

import Foundation


enum PersistanceManager {
    enum Keys {
        static let accessToken = "accessToken"
    }
    static private let defaults = UserDefaults.standard
    
    
    static func retrieveToken() throws -> String {
        guard let tokenData = defaults.object(forKey: Keys.accessToken) as? Data else {
            return ""
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(String.self, from: tokenData)
        } catch {
            throw TMUError.unableToLogIn
        }
    }
    
    
    static func saveToken(token: String) -> TMUError? {
        do {
            let enconder = JSONEncoder()
            let encodedToken = try enconder.encode(token)
            defaults.set(encodedToken, forKey: Keys.accessToken)
            return nil
        } catch {
            return .unableToSaveToken
        }
    }
    
    
    static func deleteToken() {
        defaults.set("", forKey: Keys.accessToken)
    }
}

