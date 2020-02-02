//
//  UITableView+Extensions.swift
//  ViewPrototypes
//
//  Created by Alvin Ling on 2/2/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register(cellClass: UITableViewCell.Type) {
        let reuseID = "\(cellClass)"
        register(UINib(nibName: reuseID, bundle: nil), forCellReuseIdentifier: reuseID)
    }
    
    func register(cellClasses: UITableViewCell.Type...) {
        cellClasses.forEach { register(cellClass: $0) }
    }
    
    func dequeue<T: UITableViewCell>(cellClass: T.Type) -> T? {
        return dequeueReusableCell(withIdentifier: "\(cellClass)") as? T
    }
}
