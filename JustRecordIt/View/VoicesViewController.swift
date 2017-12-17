//
//  VoicesViewController.swift
//  JustRecordIt
//
//  Created by Frank on 2017/12/16.
//  Copyright © 2017 Frank. All rights reserved.
//

import UIKit
import CoreData

class VoicesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var data: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = CoreDataManager.shared.fetchData()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension VoicesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let path = data[indexPath.row].value(forKey: "path") as? String {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "VoiceCell", for: indexPath) as? VoiceTableViewCell {
                cell.fileNameLabel.text = path
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

extension VoicesViewController: UITableViewDelegate {
    
}



