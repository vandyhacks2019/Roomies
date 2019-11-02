//
//  LivingSpaceListViewController.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import FirebaseAuth
import Ballcap

class LivingSpaceListViewController: UITableViewController {
    private var authInstance = Auth.auth()
    private var livingSpaces: DataSource<Document<LivingSpace>>!

    override init(style: UITableView.Style) {
        super.init(style: style)
        self.livingSpaces = LivingSpaceService.sharedInstance.fetchLivingSpaces()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.livingSpaces = LivingSpaceService.sharedInstance.fetchLivingSpaces()
    }

    override func viewDidLoad() {
        self.livingSpaces .onChanged({ (snapshot, dataSourceSnapshot) in
            self.tableView.performBatchUpdates({
                self.tableView.insertRows(at: dataSourceSnapshot.changes.insertions.map { IndexPath(item: dataSourceSnapshot.after.firstIndex(of: $0)!, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: dataSourceSnapshot.changes.deletions.map { IndexPath(item: dataSourceSnapshot.before.firstIndex(of: $0)!, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: dataSourceSnapshot.changes.modifications.map { IndexPath(item: dataSourceSnapshot.after.firstIndex(of: $0)!, section: 0) }, with: .automatic)
            }, completion: nil)
        })
            .listen()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.livingSpaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")
        
        guard let livingSpace = self.livingSpaces[indexPath.row].data else {
            return cell!
        }
        
        cell?.textLabel?.text = livingSpace.createdBy
        
        return cell!
    }

}
