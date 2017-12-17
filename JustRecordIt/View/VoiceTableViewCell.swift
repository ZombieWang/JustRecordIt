//
//  VoiceTableViewCell.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/17.
//  Copyright © 2017 Frank. All rights reserved.
//

import UIKit

class VoiceTableViewCell: UITableViewCell {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var playingStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        playingStatusLabel.text = nil
    }
}
