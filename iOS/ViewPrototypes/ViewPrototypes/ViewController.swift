//
//  ViewController.swift
//  ViewPrototypes
//
//  Created by Alvin Ling on 2/1/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
}

extension ViewController: UITableViewDataSource {
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        tableView.register(cellClass: OptionCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(cellClass: OptionCell.self)
        else { return UITableViewCell() }
        
        return cell
    }
}
