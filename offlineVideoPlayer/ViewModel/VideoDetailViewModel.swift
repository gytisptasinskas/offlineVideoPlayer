//
//  VideoDetailViewModel.swift
//  offlineVideoPlayer
//
//  Created by Gytis Ptasinskas on 14/02/2024.
//

import Foundation
import CoreData

@MainActor
class VideoDetailViewModel: ObservableObject {
    let video: Video
    @Published var isDownloaded = false
    private var downloadService: DownloadService
    
    init(video: Video, downloadService: DownloadService = DownloadService()) {
        self.video = video
        self.downloadService = downloadService
        checkIfVideoIsDownloaded()
    }
    
    func checkIfVideoIsDownloaded() {
        Task {
            let downloaded = await isVideoDownloaded(id: video.id)
            self.isDownloaded = downloaded
        }
    }
    
    func downloadVideo() async {
        guard let urlString = video.videos?.large?.url, let url = URL(string: urlString) else { return }

        do {
            let savedURL = try await downloadService.downloadVideo(url: url)
            await saveVideoLocally(video: video, localURL: savedURL)
        } catch {
            print("Error downloading video: \(error.localizedDescription)")
        }
    }
    
    private func saveVideoLocally(video: Video, localURL: URL) async {
        let context = CoreDataStack.shared.viewContext
        let downloadedVideo = DownloadedVideo(context: context)
        
        downloadedVideo.id = Int64(video.id)
        downloadedVideo.largeURL = video.videos?.large?.url
        downloadedVideo.localURL = localURL.path
        downloadedVideo.tags = video.tags
        downloadedVideo.thumbnailURL = video.picture_id
        downloadedVideo.user = video.user

        do {
            try context.save()
            updateDownloadedStatus(true)
        } catch {
            print("Error saving video locally: \(error.localizedDescription)")
        }
    }

    @MainActor
    private func updateDownloadedStatus(_ downloaded: Bool) {
        self.isDownloaded = downloaded
    }

    func localVideoURL() async -> URL? {
        let context = CoreDataStack.shared.viewContext
        let fetchRequest: NSFetchRequest<DownloadedVideo> = DownloadedVideo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(video.id))
        
        do {
            let results = try context.fetch(fetchRequest)
            if let downloadedVideo = results.first, let localPath = downloadedVideo.localURL {
                return URL(fileURLWithPath: localPath, relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)
            }
        } catch {
            print("Error fetching downloaded video URL: \(error.localizedDescription)")
        }
        return nil
    }

    private func isVideoDownloaded(id: Int) async -> Bool {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<DownloadedVideo> = DownloadedVideo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking video download status: \(error)")
            return false
        }
    }
}

