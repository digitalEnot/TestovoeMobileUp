//
//  PersistanceManager.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 09.08.2024.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

// TODO: сократить кол-во функций
enum PersistanceManager {
    enum Keys {
        static let accessToken = "accessToken"
    }
    
    static private let defaults = UserDefaults.standard
    
    static func updateWith(accessToken: String, actionType: PersistanceActionType) throws {
        do {
            var retrivedToken = try retrieveToken()
            
            switch actionType {
            case .add:
                retrivedToken = accessToken
            case .remove:
                retrivedToken = ""
            }
            
            if let error = saveToken(token: retrivedToken) {
                throw error
            }
        }
        catch {
            throw TMUError.unableToLogIn
        }
    }
    
    
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
            return .unableToLogIn
        }
    }
}

