//
//  PixabayService.swift
//  offlineVideoPlayer
//
//  Created by Gytis Ptasinskas on 14/02/2024.
//
import Foundation
import Alamofire

class PixabayService {
    func fetchVideos(query: String) async throws -> [Video] {
        guard let apiKey = ProcessInfo.processInfo.environment["PIXABAY_API_KEY"] else {
            throw NSError(domain: "offlinePlayer", code: 401, userInfo: [NSLocalizedDescriptionKey: "API key not found in environment variables"])
        }
        
        let url = "https://pixabay.com/api/videos/?key=\(apiKey)&q=\(query)"
        let request = AF.request(url)
        
        let response = try await request.serializingDecodable(VideoResponse.self).value
        
        return response.hits.map { hit in
            Video(id: hit.id,
                  pageURL: hit.pageURL,
                  type: hit.type,
                  tags: hit.tags,
                  duration: hit.duration,
                  picture_id: hit.picture_id,
                  videos: hit.videos,
                  views: hit.views,
                  downloads: hit.downloads,
                  likes: hit.likes,
                  comments: hit.comments,
                  user_id: hit.user_id,
                  user: hit.user,
                  userImageURL: hit.userImageURL)
        }
    }
}
