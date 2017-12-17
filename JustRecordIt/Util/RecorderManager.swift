//
//  RecorderManager.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/17.
//  Copyright © 2017 Frank. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

final class RecorderManager {
    static let shared = RecorderManager()
    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer!
    
    private init() {}
    
    func setupRecorder(viewController: UIViewController, lastRestoredDateTime: Date) {
        let fileURL = getURLforAudio(dateTime: lastRestoredDateTime)
        
        let recordSettings: [String : Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: recordSettings)
            if let currentViewController = viewController as? AVAudioRecorderDelegate {
                audioRecorder.delegate = currentViewController
            }
            audioRecorder.prepareToRecord()
        } catch {
            print("Error creating audioRecorder.")
        }
    }
    
    // MARK: Recording
    func record() {
        audioRecorder.record()
    }
    
    func stopRecording() {
        audioRecorder.stop()
    }
    
    // MARK: Playback
    func play(viewController: UIViewController, savedTime: Date) {
        let fileURL = getURLforAudio(dateTime: savedTime)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            if let currentViewController = viewController as? AVAudioPlayerDelegate {
                audioPlayer.delegate = currentViewController
            }
            
            if audioPlayer.duration > 0.0 {
                audioPlayer.play()
            }
        } catch {
            print("Error loading audioPlayer.")
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
    }
    
    private func getURLforAudio(dateTime: Date) -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        let dateString = dateFormatter.string(from: dateTime)
        
        return URL(fileURLWithPath: NSHomeDirectory() + "/Documents/\(dateString).caf")
    }
}
