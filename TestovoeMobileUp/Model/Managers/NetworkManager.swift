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
    
    
    private init() {}
    
//    func getPhotos(accessToken: String, offset: Int = 0, numberOfPhotos: Int = 143, completion: @escaping ([Photo]) -> Void) {
//        let url = "https://api.vk.com/method/photos.getAll"
//        guard let url = URL(string: url) else { return }
//        
//        let jsonData: [String: Any] = [
//            "access_token": accessToken,
//            "owner_id": -128666765,
//            "count": 143,
//            "v": "5.199",
//        ]
//        
//        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
//        let headers = [
//            "Content-Type": "application/json"
//        ]
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = headers
//        request.httpBody = data as Data
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print(error)
//            } else if let data = data {
//                do {
//                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        print(jsonObject)
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//        }
//        task.resume()
//    }
    
 
    
    func getPhotos(accessToken: String, completion: @escaping ([Photo]) -> ()) {
        let url = "https://api.vk.com/method/photos.getAll"
        
        let params: Parameters = [
            "access_token": accessToken,
            "owner_id": -128666765,
            "count": 143,
            "v": "5.199",
        ]
        
        AF.request(url, method: .post, parameters: params).response { result in
            if let data = result.data {
                if let photos = try? JSONDecoder().decode(MobileUpPhotos.self, from: data).response.items {
                    completion(photos)
                }
            }
        }
    }
    
    
    func getVideos(accessToken: String, completion: @escaping ([Video]) -> ()) {
        let url = "https://api.vk.com/method/video.get"
        
        let params: Parameters = [
            "access_token": accessToken,
            "owner_id": -128666765,
            "v": "5.199",
        ]
        
        AF.request(url, method: .post, parameters: params).response { result in
            if let data = result.data {
                if let videos = try? JSONDecoder().decode(MobileUpVideos.self, from: data).response.items {
                    completion(videos)
                }
            }
        }
    }
    
    

    
    func downloadVkPhoto(from urlString: String, completion: @escaping (UIImage?)->Void) {
        let cacheKey = NSString(string: urlString)
        if let cachedImage = cache.object(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            guard let data = data, error == nil else  {
                print("error")
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: cacheKey)
                    completion(image)
                }
            }
        }
        task.resume()
    }
}
