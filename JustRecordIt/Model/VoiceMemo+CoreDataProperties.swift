//
//  VoiceMemo+CoreDataProperties.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/16.
//  Copyright © 2017 Frank. All rights reserved.
//
//

import Foundation
import CoreData

extension VoiceMemo {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VoiceMemo> {
        return NSFetchRequest<VoiceMemo>(entityName: "VoiceMemo")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var path: String?
}
