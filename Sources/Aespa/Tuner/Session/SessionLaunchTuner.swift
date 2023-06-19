//
//  SessionLauncher.swift
//  
//
//  Created by 이영빈 on 2023/06/02.
//

import AVFoundation

struct SessionLaunchTuner: AespaSessionTuning {
    let needTransaction = false
    
    func tune<T: AespaCoreSessionRepresentable>(_ session: T) throws {
        guard session.isRunning == false else { return }
        
        try session.addMovieInput()
        try session.addMovieFileOutput()
        try session.addCapturePhotoOutput()
        session.startRunning()
    }
}


