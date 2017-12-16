//
//  RecordViewModelTests.swift
//  JustRecordItTests
//
//  Created by Frank on 2017/12/16.
//  Copyright © 2017 Frank. All rights reserved.
//

import XCTest
import UIKit
import CoreData
@testable import JustRecordIt

class RecordViewModelTests: XCTestCase {
    var sut: RecordViewModel!
    let testViewController = RecordViewController()
    
    override func setUp() {
        super.setUp()
        
        sut = RecordViewModel(viewController: testViewController)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSaveData() {
        sut.setupRecorder()
        sut.stopRecording()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VoiceMemo")
        request.predicate = NSPredicate(format: "date = %@", sut.lastRestoredDateTime! as NSDate)
        request.returnsObjectsAsFaults = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let result = try context.fetch(request)
            XCTAssertEqual(result.count, 1)
        } catch {
            XCTFail()
        }
    }
}
