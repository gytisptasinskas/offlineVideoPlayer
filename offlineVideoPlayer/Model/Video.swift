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
    
    init(id: Int, pageURL: String?, type: String?, tags: String?, duration: Int?, picture_id: String?, videos: VideoFormats?, views: Int?, downloads: Int?, likes: Int?, comments: Int?, user_id: Int?, user: String?, userImageURL: String?) {
        self.id = id
        self.pageURL = pageURL
        self.type = type
        self.tags = tags
        self.duration = duration
        self.picture_id = picture_id
        self.videos = videos
        self.views = views
        self.downloads = downloads
        self.likes = likes
        self.comments = comments
        self.user_id = user_id
        self.user = user
        self.userImageURL = userImageURL
    }
    
    init(from downloadedVideo: DownloadedVideo) {
        self.id = Int(downloadedVideo.id)
        self.pageURL = nil
        self.type = nil
        self.tags = downloadedVideo.tags
        self.duration = nil
        self.picture_id = downloadedVideo.thumbnailURL
        self.videos = VideoFormats(large: VideoFormatDetail(url: downloadedVideo.largeURL, width: nil, height: nil, size: nil), medium: nil, small: nil, tiny: nil)
        self.views = nil
        self.downloads = nil
        self.likes = nil
        self.comments = nil
        self.user_id = nil
        self.user = downloadedVideo.user
        self.userImageURL = nil
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

