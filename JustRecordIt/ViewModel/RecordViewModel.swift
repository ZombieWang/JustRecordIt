//
//  RecordViewModel.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/15.
//  Copyright © 2017 Frank. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreData

class RecordViewModel {
    private let appDelegate: AppDelegate
    private let context: NSManagedObjectContext
    private var viewController: RecordViewController!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var lastRestoredDateTime: Date?
    
    init(viewController: RecordViewController) {
        self.viewController = viewController
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    func setupRecorder() {
        lastRestoredDateTime = Date()
        let fileURL = getURLforAudio(dateTime: lastRestoredDateTime!)
        
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
    }
    
    func stopRecording() {
        audioRecorder.stop()
        saveData(savedDateTime: lastRestoredDateTime!)
    }
    
    // MARK: Playback
    func play() {
        if let lastSavedDateTime = lastRestoredDateTime {
            let fileURL = getURLforAudio(dateTime: lastSavedDateTime)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                audioPlayer.delegate = viewController
                
                if audioPlayer.duration > 0.0 {
                    audioPlayer.play()
                }
            } catch {
                print("Error loading audioPlayer.")
            }
        } else {
            print("No saved voice memo.")
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
    }
    
    // MARK: Save to CoreData
    private func saveData(savedDateTime: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:00"
        
        let dateString = dateFormatter.string(from: savedDateTime)
        
        let newRecord = NSEntityDescription.insertNewObject(forEntityName: "VoiceMemo", into: context)
        newRecord.setValue(savedDateTime, forKey: "date")
        newRecord.setValue(dateString, forKey: "name")
        newRecord.setValue("\(dateString).caf", forKey: "path")
        
        do {
            try context.save()
            print("VoiceMemo saved.")
        } catch {
            print("There was an error.")
        }
    }
    
    private func getURLforAudio(dateTime: Date) -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:00"
        
        let dateString = dateFormatter.string(from: dateTime)
        
        return URL(fileURLWithPath: NSHomeDirectory() + "/Documents/\(dateString).caf")
    }
}
