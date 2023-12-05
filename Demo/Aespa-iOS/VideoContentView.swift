//
//  VideoContentView.swift
//  Aespa-iOS
//
//  Created by 이영빈 on 2023/06/07.
//

import Aespa
import SwiftUI

struct VideoContentView: View {
    @State var isRecording = false
    @State var isFront = false
    
    @State var showSetting = false
    @State var showGallery = false
    
    @State var captureMode: AssetType = .video
    
    @ObservedObject private var viewModel = VideoContentViewModel()
    
    var body: some View {
        ZStack {
            viewModel.preview
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       minHeight: 0,
                       maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ZStack(alignment: .center) {
                    // Mode change
                    Picker("Capture Modes", selection: $captureMode) {
                        Text("Video").tag(AssetType.video)
                        Text("Photo").tag(AssetType.photo)
                    }
                    .pickerStyle(.segmented)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                    .frame(width: 200)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: { showSetting = true }) {
                            Image(systemName: "gear")
                                .resizable()
                                .foregroundColor(.white)
                                .scaledToFit()
                                .frame(width: 30, height: 30)

                        }
                        .padding(20)
                        .contentShape(Rectangle())
                    }
                }
                
                Spacer()
                
                ZStack {
                    HStack {
                        // Album thumbnail + button
                        Button(action: { showGallery = true }) {
                            let coverImage = (
                                captureMode == .video
                                ? viewModel.videoAlbumCover
                                : viewModel.photoAlbumCover)
                            ?? Image("")
                            
                            roundRectangleShape(with: coverImage, size: 80)
                        }
                        .shadow(radius: 5)
                        .contentShape(Rectangle())
                        
                        Spacer()
                        
                        // Position change + button
                        Button(action: {
                            viewModel.aespaSession.common(.position(position: isFront ? .back : .front))
                            isFront.toggle()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding(20)
                                .padding(.trailing, 20)
                        }
                        .shadow(radius: 5)
                        .contentShape(Rectangle())
                    }
                    
                    // Shutter + button
                    recordingButtonShape(width: 60).onTapGesture {
                        switch captureMode {
                        case .video:
                            if isRecording {
                                viewModel.aespaSession.stopRecording()
                                isRecording = false
                            } else {
                                viewModel.aespaSession.startRecording(autoVideoOrientationEnabled: true)
                                isRecording = true
                            }
                        case .photo:
                            viewModel.aespaSession.capturePhoto(autoVideoOrientationEnabled: true)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showSetting) {
            SettingView(contentViewModel: viewModel)
        }
        .sheet(isPresented: $showGallery) {
            GalleryView(mediaType: $captureMode, contentViewModel: viewModel)
        }
    }
}

extension VideoContentView {
    @ViewBuilder
    func roundRectangleShape(with image: Image, size: CGFloat) -> some View {
        image
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size, alignment: .center)
            .clipped()
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 1)
            )
            .padding(20)
    }
    
    @ViewBuilder
    func recordingButtonShape(width: CGFloat) -> some View {
        ZStack {
            Circle()
                .strokeBorder(isRecording ? .red : .white, lineWidth: 3)
                .frame(width: width)
            
            Circle()
                .fill(isRecording ? .red : .white)
                .frame(width: width * 0.8)
        }
        .frame(height: width)
    }
}

enum AssetType {
    case video
    case photo
}

struct VideoContentView_Previews: PreviewProvider {
    static var previews: some View {
        VideoContentView()
    }
}
