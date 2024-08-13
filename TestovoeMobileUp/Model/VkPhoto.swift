//
//  VkPhoto.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 10.08.2024.
//

import Foundation


struct MobileUpPhotos: Codable {
    let response: Photos
}


struct Photos: Codable {
//    let count: Int
    let items: [Photo]
}


struct Photo: Codable, Hashable {
    let date: Int
//    let origPhoto: OrigPhoto
    let sizes: [Sizes]

    enum CodingKeys: String, CodingKey {
        case date
        case sizes
//        case origPhoto = "orig_photo"
    }
}

//struct OrigPhoto: Codable, Hashable {
//    let height: Int
//    let type: String
//    let url: String
//    let width: Int
//}

struct Sizes: Codable, Hashable {
    let height: Int
    let type: TypeEnum
    let width : Int
    let url: String
}

enum TypeEnum: String, Codable {
    case base = "base"
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}
