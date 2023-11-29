//
//  SettingView.swift
//  Aespa-iOS
//
//  Created by Young Bin on 2023/06/08.
//

import SwiftUI
import AVFoundation

struct SettingView: View {
    @ObservedObject var viewModel: VideoContentViewModel

    @State private var quality: AVCaptureSession.Preset
    @State private var focusMode: AVCaptureDevice.FocusMode
    
    @State private var isMuted: Bool
    
    @State private var flashMode: AVCaptureDevice.FlashMode
    
    init(contentViewModel viewModel: VideoContentViewModel) {
        self.viewModel = viewModel
        
        self.quality = viewModel.aespaSession.avCaptureSession.sessionPreset
        self.focusMode = viewModel.aespaSession.currentFocusMode ?? .continuousAutoFocus
        
        self.isMuted = viewModel.aespaSession.isMuted
        
        self.flashMode = viewModel.aespaSession.currentSetting.flashMode
    }
    
    var body: some View {
        List {
            Section(header: Text("Common")) {
                Picker("Quality", selection: $quality) {
                    Text("Low").tag(AVCaptureSession.Preset.low)
                    Text("Medium").tag(AVCaptureSession.Preset.medium)
                    Text("High").tag(AVCaptureSession.Preset.high)
                }
                .modifier(TitledPicker(title: "Asset quality"))
                .onChange(of: quality) { newValue in
                    viewModel.aespaSession.common(.quality(preset: newValue))
                }
                
                Picker("Focus", selection: $focusMode) {
                    Text("Auto").tag(AVCaptureDevice.FocusMode.autoFocus)
                    Text("Locked").tag(AVCaptureDevice.FocusMode.locked)
                    Text("Continuous").tag(AVCaptureDevice.FocusMode.continuousAutoFocus)
                }
                .modifier(TitledPicker(title: "Focus mode"))
                .onChange(of: focusMode) { newValue in
                    viewModel.aespaSession.common(.focus(mode: newValue))
                }
            }
            
            Section(header: Text("Video")) {
                Picker("Mute", selection: $isMuted) {
                    Text("Unmute").tag(false)
                    Text("Mute").tag(true)
                }
                .modifier(TitledPicker(title: "Mute"))
                .onChange(of: isMuted) { newValue in
                    viewModel.aespaSession.video(newValue ? .mute : .unmute)
                }
            }
            
            Section(header: Text("Photo")) {
                Picker("Flash", selection: $flashMode) {
                    Text("On").tag(AVCaptureDevice.FlashMode.on)
                    Text("Off").tag(AVCaptureDevice.FlashMode.off)
                    Text("Auto").tag(AVCaptureDevice.FlashMode.auto)
                }
                .modifier(TitledPicker(title: "Flash mode"))
                .onChange(of: flashMode) { newValue in
                    viewModel.aespaSession.photo(.flashMode(mode: newValue))
                }
            }
        }
    }
    
    struct TitledPicker: ViewModifier {
        let title: String
        func body(content: Content) -> some View {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.gray)
                    .font(.caption)
                
                content
                    .pickerStyle(.segmented)
                    .frame(height: 40)
            }
        }
    }
}
