//
//  VideoListView.swift
//  offlineVideoPlayer
//
//  Created by Gytis Ptasinskas on 14/02/2024.
//

import SwiftUI
import Kingfisher

struct VideoListView: View {
    @StateObject var viewModel = VideoListViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.videos) { video in
                NavigationLink {
                    VideoDetailView(viewModel: VideoDetailViewModel(video: video))
                } label: {
                    VStack {
                        HStack(spacing: 20) {
                            KFImage(URL(string: video.thumbnailURL ?? ""))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 80)
                            
                            VStack(alignment: .leading) {
                                Text(video.user ?? "N/A")
                                    .font(.headline)
                                    .lineLimit(1)
                                
                                Text(video.tags ?? "N/A")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Videos")
            .onAppear {
                Task {
                    await viewModel.fetchVideos()
                }
            }
        }
    }
}

#Preview {
    VideoListView()
}
