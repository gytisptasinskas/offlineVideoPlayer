//
//  VideoListViewModel.swift
//  offlineVideoPlayer
//
//  Created by Gytis Ptasinskas on 14/02/2024.
//

import Foundation
import Network

class VideoListViewModel: ObservableObject {
    @Published var videos: [Video] = []
    
    private var videoService = PixabayService()
    
    @MainActor
    func fetchVideos() async {
        do {
            let videoItems = try await videoService.fetchVideos(query: "Dogs")
            self.videos = videoItems
        } catch {
            print("Error fetching videos: \(error)")
        }
    }
}
