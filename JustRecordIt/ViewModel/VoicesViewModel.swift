//
//  VoicesViewModel.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/16.
//  Copyright © 2017 Frank. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreData

final class VoicesViewModel {
    private unowned let viewController: VoicesViewController
    var data: [NSManagedObject] = []
    var currentPlayingRow: Int?
    
    init(viewController: VoicesViewController) {
        self.viewController = viewController
        data = CoreDataManager.shared.fetchData()
    }

    func play(viewController: VoicesViewController, savedTime: Date) {
        RecorderManager.shared.play(viewController: viewController, savedTime: savedTime)
    }
    
    func stop() {
        RecorderManager.shared.stopPlayback()
    }
}
