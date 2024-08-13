//
//  TokenManager.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 11.08.2024.
//

import Foundation

// TODO: перебросить в NetworkManager
class TokenManager {
    static let shared = TokenManager()
    
    private init() {}
    
    func getAccessToken(deviceId: String, code: String, completion: @escaping (String) -> ()) {
        let url = URL(string: "https://id.vk.com/oauth2/auth?grant_type=authorization_code&redirect_uri=vk52118206://vk.com/blank.html&client_id=52118206&device_id=\(deviceId)&state=abracadabra&code_verifier=EFuq4gKZjJITd0lDvdG7HtKkTXT1rz0tV9Tx6ExNuJAwH1xQ4V22o77xUOJaozMbjJt2oBw5bmGTm0kfMxqxOpsrqDeeHmn1jJjdXa-jlf4sYBB1XGFGNnTqkuJPtU_A")!
        
        let jsonData: [String: Any] = [
            "code": code
        ]
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
        let headers = [
            "Content-Type": "application/json"
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let id_user = jsonObject["user_id"] as? Int {
                            print("USER_ID: \(id_user)")
                        }
                        
                        if let accessToken = jsonObject["access_token"] as? String {
                            completion(accessToken)
                        } else {
                            print("Access Token not found")
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
