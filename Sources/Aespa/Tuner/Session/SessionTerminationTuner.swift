//
//  SessionTerminationTuner.swift
//  
//
//  Created by Young Bin on 2023/06/10.
//

import AVFoundation

struct SessionTerminationTuner: AespaSessionTuning {
    let needTransaction = false
    
    func tune(_ session: some AespaCoreSessionRepresentable) {
        guard session.isRunning else { return }
        
        session
            .removeAudioInput()
            .removeMovieInput()
            .stopRunning()
    }
}
