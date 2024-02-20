//
//  VideoListViewModel.swift
//  offlineVideoPlayer
//
//  Created by Gytis Ptasinskas on 14/02/2024.
//

import Foundation
import CoreData

class VideoListViewModel: ObservableObject {
    @Published var videos: [Video] = []
    
    private var videoService = PixabayService()
    
    @MainActor
    func fetchVideos() async {
        do {
            let videoItems = try await videoService.fetchVideos(query: "Dogs")
            self.videos = videoItems
        } catch {
            print("Error fetching videos: \(error.localizedDescription), showing locally saved videos.")
            await fetchLocallySavedVideos()
        }
    }
    
    @MainActor
    private func fetchLocallySavedVideos() async {
        let context = CoreDataStack.shared.viewContext
        let fetchRequest: NSFetchRequest<DownloadedVideo> = DownloadedVideo.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            self.videos = results.map(Video.init)
        } catch {
            print("Error fetching locally saved videos: \(error.localizedDescription)")
        }
    }
}
