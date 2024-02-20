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
        VStack(alignment: .leading) {
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
                .font(.title)
                .fontWeight(.semibold)
            
            Text(viewModel.video.tags ?? "No Tags")
                .font(.subheadline)
                .padding(.bottom)
            
            Spacer()
        }
        .toolbar {
            Button {
                Task {
                    await viewModel.downloadVideo()
                }
            } label: {
                Image(systemName: "square.and.arrow.down")
                    .foregroundStyle(viewModel.isDownloaded ? Color.gray : Color.blue)
            }
            .disabled(viewModel.isDownloaded)
        }
        .task {
            await setupVideoPlayer()
        }
        .navigationTitle(viewModel.video.user ?? "Video Detail")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
    
    private func setupVideoPlayer() async {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        if let localPath = await viewModel.localVideoURL() {
            let fullLocalURL = documentsDirectory.appendingPathComponent(localPath.path)
            
            if fileManager.fileExists(atPath: fullLocalURL.path) {
                print("Playing from local storage: \(fullLocalURL.path)")
                player = AVPlayer(url: fullLocalURL)
            } else {
                print("Local file not found at: \(fullLocalURL.path)")
            }
        } else if let remoteURLString = viewModel.video.videos?.large?.url, let remoteURL = URL(string: remoteURLString) {
            print("Playing from remote URL: \(remoteURLString)")
            player = AVPlayer(url: remoteURL)
        }
        
        player?.play()
    }
}

#Preview {
    VideoDetailView(viewModel: VideoDetailViewModel(video: Video.previewVideo))
}
