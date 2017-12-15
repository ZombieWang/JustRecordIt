//
//  RecordViewModel.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/15.
//  Copyright © 2017 Frank. All rights reserved.
//

import Foundation
import AVFoundation

enum AudioStatus: Int, CustomStringConvertible {
    case stopped = 0,
    playing,
    recording
    
    var audioName: String {
        let audioNames = [
            "Audio: Stopped",
            "Audio:Playing",
            "Audio:Recording"
        ]
        return audioNames[rawValue]
    }
    
    var description: String {
        return audioName
    }
}

class RecordViewModel {
    private var viewController: RecordViewController!
    var audioStatus: AudioStatus = .stopped
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    init(viewController: RecordViewController) {
        self.viewController = viewController
    }
    
    func setupRecorder() {
        let fileURL = getURLforAudio()
        
        let recordSettings: [String : Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: recordSettings)
            audioRecorder.delegate = viewController
            audioRecorder.prepareToRecord()
        } catch {
            print("Error creating audioRecorder.")
        }
    }
    
    // MARK: Recording
    func record() {
        audioRecorder.record()
        audioStatus = .recording
    }
    
    func stopRecording() {
        audioRecorder.stop()
        audioStatus = .stopped
    }
    
    // MARK: Playback
    func play() {
        let fileURL = getURLforAudio()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.delegate = viewController
            if audioPlayer.duration > 0.0 {
                audioPlayer.play()
                audioStatus = .playing
            }
        } catch {
            print("Error loading audioPlayer.")
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        audioStatus = .stopped
    }
    
    private func getURLforAudio() -> URL {
        return URL(fileURLWithPath: NSHomeDirectory() + "/Documents/TempMemo.caf")
    }
}
