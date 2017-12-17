//
//  VoicesViewController.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/16.
//  Copyright © 2017 Frank. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class VoicesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: VoicesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = VoicesViewModel(viewController: self)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension VoicesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let name = viewModel.data[indexPath.row].value(forKey: "name") as? String {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "VoiceCell", for: indexPath) as? VoiceTableViewCell {
                cell.fileNameLabel.text = name
                cell.playButton.tag = indexPath.row
                cell.playButton.addTarget(self, action: #selector(playButtonClick(sender:)), for: .touchUpInside)
                
                if let currentPlayingRow = viewModel.currentPlayingRow, currentPlayingRow == indexPath.row {
                    cell.playingStatusLabel.text = "Playing..."
                } else {
                    cell.playingStatusLabel.text = nil
                }
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func playButtonClick(sender: UIButton) {
        if let date = viewModel.data[sender.tag].value(forKey: "date") as? Date {
            viewModel.currentPlayingRow = sender.tag
            viewModel.play(viewController: self, savedTime: date)
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

extension VoicesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.stop()
        viewModel.currentPlayingRow = nil
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension VoicesViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        viewModel.currentPlayingRow = nil
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

