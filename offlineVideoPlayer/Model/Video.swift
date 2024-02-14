//
//  Video.swift
//  offlineVideoPlayer
//
//  Created by Gytis Ptasinskas on 14/02/2024.
//

import Foundation

struct Video: Identifiable, Codable, Hashable {
    let id: Int
    let pageURL: String?
    let type: String?
    let tags: String?
    let duration: Int?
    let picture_id: String?
    let videos: VideoFormats?
    let views: Int?
    let downloads: Int?
    let likes: Int?
    let comments: Int?
    let user_id: Int?
    let user: String?
    let userImageURL: String?
    
    var uuid: String { String(id) }
    var thumbnailURL: String? {
         guard let pictureId = picture_id else { return nil }
         return "https://i.vimeocdn.com/video/\(pictureId)_640x360.jpg"
     }
}


struct VideoResponse: Codable {
    let total: Int
    let totalHits: Int
    let hits: [Video]
}

struct VideoFormats: Codable, Hashable {
    let large: VideoFormatDetail?
    let medium: VideoFormatDetail?
    let small: VideoFormatDetail?
    let tiny: VideoFormatDetail?
}

struct VideoFormatDetail: Codable, Hashable {
    let url: String?
    let width: Int?
    let height: Int?
    let size: Int?
}
