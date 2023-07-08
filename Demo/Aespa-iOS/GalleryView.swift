//
//  GalleryView.swift
//  Aespa-iOS
//
//  Created by 이영빈 on 2023/06/12.
//

import Aespa
import SwiftUI

struct GalleryView: View {
    @ObservedObject var viewModel: VideoContentViewModel
    
    @Binding private var mediaType: AssetType
    
    init(
        mediaType: Binding<AssetType>,
        contentViewModel viewModel: VideoContentViewModel
    ) {
        self._mediaType = mediaType
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Picker("File", selection: $mediaType) {
                Text("Video").tag(AssetType.video)
                Text("Photo").tag(AssetType.photo)
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
            .padding(.vertical)
            
            ScrollView {
                switch mediaType {
                case .photo:
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 5
                    ) {
                        ForEach(viewModel.photoFiles) { file in
                            let image = file.image
                            
                            image
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .onAppear {
                        viewModel.fetchPhotoFiles()
                    }
                case .video:
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 5
                    ) {
                        ForEach(viewModel.videoFiles) { file in
                            let image = file.thumbnailImage
                            
                            image
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .onAppear {
                        viewModel.fetchVideoFiles()
                    }
                }
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(mediaType: .constant(.video), contentViewModel: .init())
    }
}
