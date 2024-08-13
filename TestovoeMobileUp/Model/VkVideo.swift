//
//  VkVideo.swift
//  TestovoeMobileUp
//
//  Created by Evgeni Novik on 13.08.2024.
//

import Foundation

struct MobileUpVideos: Codable {
    let response: Videos
}

struct Videos: Codable {
    let count: Int
    let items: [Video]
}

struct Video: Codable {
    let description: String
    let image: [VideoPreview]
    let player: String
}

struct VideoPreview: Codable {
    let url: String
    let width, height: Int
}
