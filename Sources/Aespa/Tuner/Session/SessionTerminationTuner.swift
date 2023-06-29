//
//  SessionTerminationTuner.swift
//  
//
//  Created by Young Bin on 2023/06/10.
//

import AVFoundation

struct SessionTerminationTuner: AespaSessionTuning {
    let needTransaction = false

    func tune<T: AespaCoreSessionRepresentable>(_ session: T) {
        guard session.isRunning else { return }

        session.removeAudioInput()
        session.removeMovieInput()
        session.stopRunning()
        
        Logger.log(message: "Session is terminated successfully")
    }
}
