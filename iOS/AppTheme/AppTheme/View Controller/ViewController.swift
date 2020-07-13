//
//  ViewController.swift
//  AppTheme
//
//  Created by Alvin Ling on 10/18/19.
//  Copyright © 2019 Alvin Ling. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    
    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }


}

