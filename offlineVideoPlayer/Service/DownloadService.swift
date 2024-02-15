//
//  DownloadService.swift
//  offlineVideoPlayer
//
//  Created by Gytis Ptasinskas on 14/02/2024.
//

import Foundation

class DownloadService {
    func downloadVideo(url: URL) async throws -> URL {
        let (tempLocalUrl, response) = try await URLSession.shared.download(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let savedURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        
        try? fileManager.removeItem(at: savedURL)
        try fileManager.moveItem(at: tempLocalUrl, to: savedURL)
        
        return URL(fileURLWithPath: url.lastPathComponent)
    }
}


