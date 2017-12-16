//
//  RecordViewModel.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/15.
//  Copyright © 2017 Frank. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RecordViewModel {
    private let appDelegate: AppDelegate
    private let context: NSManagedObjectContext
    private var viewController: RecordViewController!
    var lastRestoredDateTime: Date?
    
    init(viewController: RecordViewController) {
        self.viewController = viewController
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    // MARK: Recording
    func record() {
           lastRestoredDateTime = Date()
        RecorderManager.shared.setupRecorder(viewController: viewController, lastRestoredDateTime: lastRestoredDateTime!)
        RecorderManager.shared.record()
    }
    
    func stopRecording() {
        RecorderManager.shared.stopRecording()
        saveData(savedDateTime: lastRestoredDateTime!)
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
