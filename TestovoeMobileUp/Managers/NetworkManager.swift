//
//  NetworkManager.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 10.08.2024.
//

import UIKit
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    
    private init() { }
    

    func getPhotos(accessToken: String, count: Int = 30, offset: Int, completion: @escaping (Result<Photos, TMUError>) -> ()) {
        let url = "https://api.vk.com/method/photos.getAll"
        let params: Parameters = [
            "access_token": accessToken,
            "owner_id": -128666765,
            "offset": offset,
            "count": count,
            "v": "5.199",
        ]
        
        AF.request(url, method: .post, parameters: params).response { response in
            if response.error != nil {
                completion(.failure(TMUError.problemsWithTheNetwork))
                return
            }
            guard let data = response.data else {
                completion(.failure(TMUError.problemsWithTheNetwork))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(MobileUpPhotos.self, from: data)
                completion(.success(decodedResponse.response))
            } catch {
                completion(.failure(TMUError.tokenHasExpired))
            }
        }
    }
    
    
    func getVideos(accessToken: String, completion: @escaping (Result<[Video], TMUError>) -> ()) {
        let url = "https://api.vk.com/method/video.get"
        let params: Parameters = [
            "access_token": accessToken,
            "owner_id": -128666765,
            "v": "5.199",
        ]
        
        AF.request(url, method: .post, parameters: params).response { response in
            if response.error != nil {
                completion(.failure(TMUError.problemsWithTheNetwork))
                return
            }
            guard let data = response.data else {
                completion(.failure(TMUError.problemsWithTheNetwork))
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(MobileUpVideos.self, from: data)
                completion(.success(decodedResponse.response.items))
            } catch {
                completion(.failure(TMUError.tokenHasExpired))
            }
        }
    }
    

    func downloadVkPhoto(from urlString: String) async throws -> UIImage {
        let cacheKey = NSString(string: urlString)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        guard let url = URL(string: urlString) else {
            throw TMUError.problemsWithURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw TMUError.problemsWithTheNetwork
        }
        guard let image = UIImage(data: data) else {
            throw TMUError.problemsWithConvertingDataIntoImage
        }
        
        cache.setObject(image, forKey: cacheKey)
        return image
    }


    func getAccessToken(deviceId: String, code: String) async throws -> String {
        guard let url = URL(string: "https://id.vk.com/oauth2/auth?grant_type=authorization_code&redirect_uri=vk52118206://vk.com/blank.html&client_id=52118206&device_id=\(deviceId)&state=abracadabra&code_verifier=EFuq4gKZjJITd0lDvdG7HtKkTXT1rz0tV9Tx6ExNuJAwH1xQ4V22o77xUOJaozMbjJt2oBw5bmGTm0kfMxqxOpsrqDeeHmn1jJjdXa-jlf4sYBB1XGFGNnTqkuJPtU_A") else {
            throw TMUError.problemsWithURL
        }
        
        let jsonData: [String: Any] = [
            "code": code
        ]
        let data: Data
        do {
            data = try JSONSerialization.data(withJSONObject: jsonData, options: [])
        } catch {
            throw TMUError.problemsWithTheNetwork
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        let (responseData, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw TMUError.problemsWithTheNetwork
        }
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                if let accessToken = jsonObject["access_token"] as? String {
                    return accessToken
                } else {
                    throw TMUError.problemsWithToken
                }
            } else {
                throw TMUError.problemsWithToken
            }
        } catch {
            throw TMUError.problemsWithToken
        }
    }
}
