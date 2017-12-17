//
//  ViewController.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/15.
//  Copyright © 2017 Frank. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    private var viewModel: RecordViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = RecordViewModel(viewController: self)
        
        statusLabel.text = nil
        playButton.isHidden = true
    }
    
    private func setPlayButtonOn(flag: Bool) {
        if flag {
            playButton.setBackgroundImage(UIImage(named: "button-play1"), for: .normal)
        } else {
            playButton.setBackgroundImage(UIImage(named: "button-play"), for: .normal)
        }
    }
    
    @IBAction func onRecord(_ sender: UIButton) {
        recordButton.setBackgroundImage(UIImage(named: "button-record1"), for: .normal)
        statusLabel.text = "Recording..."
        
        viewModel.record()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        recordButton.setBackgroundImage(UIImage(named: "button-record"), for: .normal)
        viewModel.stopRecording()
        
        statusLabel.text = nil
        playButton.isHidden = false
    }
    
    @IBAction func onPlay(_ sender: UIButton) {
        viewModel.play()
        statusLabel.text = "Playing..."
    }
    
    @IBAction func VoicesButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ToVoicesViewController", sender: nil)
    }
}

extension RecordViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        setPlayButtonOn(flag: false)
        statusLabel.text = nil
    }
}

extension RecordViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        statusLabel?.text = nil
    }
}
