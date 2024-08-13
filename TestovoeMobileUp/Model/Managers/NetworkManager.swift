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
    
    
    func getFriends(accessToken: String, completion: @escaping ([Photo]) -> ()) {
        let url = "https://api.vk.com/method/photos.getAll"
        
        let params: Parameters = [
            "access_token": accessToken,
            "owner_id": -128666765,
            "count": 30,
            "v": "5.199",
        ]
        
        AF.request(url, method: .post, parameters: params).response { result in
            if let data = result.data {
                if let friends = try? JSONDecoder().decode(MobileUpPhotos.self, from: data).response.items {
                    completion(friends)
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
