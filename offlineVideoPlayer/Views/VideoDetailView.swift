//
//  VideoDetailView.swift
//  offlineVideoPlayer
//
//  Created by Gytis Ptasinskas on 14/02/2024.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    @StateObject var viewModel: VideoDetailViewModel
    @State private var videoURL: URL?
    @State private var player: AVPlayer?
    var body: some View {
        VStack {
            
            if let player = player {
                VideoPlayer(player: player)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .onAppear {
                        player.play()
                    }
                    .padding()
            } else {
                Text("Loading video...")
                    .padding()
            }
            
            Text(viewModel.video.user ?? "Unknown User")
                .font(.headline)
            
            Text(viewModel.video.tags ?? "No Tags")
                .font(.subheadline)
                .padding(.bottom)
        }
        .toolbar {
            Button{
                Task {
                    await viewModel.downloadVideo()
                }
            } label: {
                Image(systemName: "square.and.arrow.down")
                    .foregroundStyle(viewModel.isDownloaded ? Color.gray : Color.blue)
            }
            .disabled(viewModel.isDownloaded)
        }
        .onAppear {
            Task {
                await setupVideoPlayer()
            }
        }
        .navigationTitle(viewModel.video.user ?? "Video Detail")
        .padding()
    }
    
    private func setupVideoPlayer() async {
        if let localURL = await viewModel.localVideoURL() {
            print("Playing from local storage: \(localURL.path)")
            player = AVPlayer(url: localURL)
            player?.play()
        } else if let remoteURLString = viewModel.video.videos?.large?.url, let remoteURL = URL(string: remoteURLString) {
            print("Playing from remote URL: \(remoteURLString)")
            player = AVPlayer(url: remoteURL)
            player?.play()
        }
    }
}

#Preview {
    VideoDetailView(viewModel: VideoDetailViewModel(video: Video.previewVideo))
}
