//
//  VideoDetailView.swift
//  offlineVideoPlayer
//
//  Created by Gytis Ptasinskas on 14/02/2024.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    @StateObject var viewModel = VideoDetailViewModel()
    let video: Video
    
    var body: some View {
        VStack {
            if let videoURL = URL(string: video.videos?.large?.url ?? "") {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
            }
        }
        
        Text(video.user ?? "N/A")
            .font(.headline)
        Text(video.tags ?? "N/A")
            .font(.subheadline)
        
        Spacer()
    }
}

#Preview {
    VideoDetailView(video: Video.previewVideo)
}
