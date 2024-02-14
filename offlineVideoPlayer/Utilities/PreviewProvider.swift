//
//  PreviewProvider.swift
//  offlineVideoPlayer
//
//  Created by Gytis Ptasinskas on 14/02/2024.
//

import Foundation

extension Video {
    static var previewVideo: Video {
        return Video(
            id: 12345,
            pageURL: "https://pixabay.com/videos/id-12345/",
            type: "film",
            tags: "nature, forest, trees",
            duration: 120,
            picture_id: "529927645",
            videos: VideoFormats(
                large: VideoFormatDetail(url: "https://example.com/large.mp4", width: 1920, height: 1080, size: 100000),
                medium: VideoFormatDetail(url: "https://example.com/medium.mp4", width: 1280, height: 720, size: 50000),
                small: VideoFormatDetail(url: "https://example.com/small.mp4", width: 640, height: 360, size: 25000),
                tiny: VideoFormatDetail(url: "https://example.com/tiny.mp4", width: 320, height: 180, size: 12500)
            ),
            views: 100,
            downloads: 50,
            likes: 10,
            comments: 2,
            user_id: 67890,
            user: "SampleUser",
            userImageURL: "https://example.com/user.jpg"
        )
    }
}
