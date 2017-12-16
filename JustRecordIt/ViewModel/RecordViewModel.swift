//
//  RecordViewModel.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/15.
//  Copyright © 2017 Frank. All rights reserved.
//

import Foundation

class RecordViewModel {
    private var viewController: RecordViewController!
    var lastRestoredDateTime: Date?
    
    init(viewController: RecordViewController) {
        self.viewController = viewController
    }
    
    // MARK: Recording
    func record() {
        lastRestoredDateTime = Date()
        RecorderManager.shared.setupRecorder(viewController: viewController, lastRestoredDateTime: lastRestoredDateTime!)
        RecorderManager.shared.record()
    }
    
    func stopRecording() {
        RecorderManager.shared.stopRecording()
        CoreDataManager.shared.saveData(savedDateTime: lastRestoredDateTime!)
    }
    
    // MARK: Playback
    func play() {
        if let lastRestoredDateTime = lastRestoredDateTime {
            RecorderManager.shared.play(viewController: viewController, savedTime: lastRestoredDateTime)
        }
    }
    
    func stopPlayback() {
        RecorderManager.shared.stopPlayback()
    }
}
