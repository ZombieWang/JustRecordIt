//
//  CoreDataManager.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/17.
//  Copyright © 2017 Frank. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let appDelegate: AppDelegate
    private let context: NSManagedObjectContext
    
    private init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    // MARK: Save to CoreData
    func saveData(savedDateTime: Date) {
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
}
