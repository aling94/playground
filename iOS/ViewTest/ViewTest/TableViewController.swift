//
//  TableViewController.swift
//  ViewTest
//
//  Created by Alvin Ling on 2/26/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.negativeFormat = formatter.positiveFormat
        formatter.roundingMode = .halfUp
        
        let str = formatter.string(from: NSNumber(value: -1 * 3.04)) ?? ""
        let sstr = str[str.index(after: str.startIndex)...]
        label.text = String(format: "%@", String(sstr))

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        setupTableHeader()
        tableView.useDynamicHeightHeader()
        tableView.useDynamicHeightFooter()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}

extension UITableView {
    
    func viewWithDynamicHeight(from view: UIView?, _ callback: ((UIView) -> Void)) {
        guard let view = view else { return }
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        guard view.frame.size.height != size.height else { return }
        view.frame.size.height = size.height
        callback(view)
        layoutIfNeeded()
    }
    
    func useDynamicHeightHeader() {
        viewWithDynamicHeight(from: tableHeaderView) { tableHeaderView = $0 }
    }
    
    func useDynamicHeightFooter() {
        viewWithDynamicHeight(from: tableFooterView) { tableFooterView = $0 }
    }
    
    func setDynamicHeight(_ view: inout UIView?) {
        guard let view = view else { return }
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        guard view.frame.size.height != size.height else { return }
        view.frame.size.height = size.height
        layoutIfNeeded()
    }
}
