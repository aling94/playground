//
//  AppearanceManager.swift
//  AppTheme
//
//  Created by Alvin Ling on 10/24/19.
//  Copyright © 2019 Alvin Ling. All rights reserved.
//

import UIKit

struct AppearanceManager {
    
    static let shared = AppearanceManager()
    
    private init() {
        setupNavBars()
        setupTabBars()
        setupTextViews()
        setupTabBars()
        setupCollectionViews()
        setupTableViews()
        setupSearchBars()
    }
}

private extension AppearanceManager {
    func setupNavBars() {
        let navBars = UINavigationBar.appearance()
        // Bar background has three layers start from bottom-most: backgroundColor, barTint, backgroundImage
        navBars.backgroundColor = .black
        navBars.barTintColor = .red
        navBars.setBackgroundImage(UIImage(color: .blue), for: .default)
        // Tint color of nav bar buttons (affects button title color too)
        navBars.tintColor = .green
        // Title attributes
        navBars.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]
        // When translucent is true, background is translucent and barTint is hidden
        navBars.isTranslucent = false
        
        // Other ways of styling buttons in nav bar
        let navBarButtons = UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        navBarButtons.backgroundColor = .purple
        navBarButtons.tintColor = .white
    }
    
    func setupTabBars() {
        let tabBars = UITabBar.appearance()
        // Layer order from bottom-most: backgroundColor, barTint, backgroundImage
        tabBars.backgroundColor = .red
        tabBars.barTintColor = .orange
        tabBars.backgroundImage = UIImage(color: .blue)
        // Icon tints
        tabBars.tintColor = .white
//        tabBars.unselectedItemTintColor = .green
        tabBars.isTranslucent = false
        
        let tabBarItems = UITabBarItem.appearance()
        // unselectedItemTintColor seems to take priority over .normal titleTextAttributes
        tabBarItems.setTitleTextAttributes(UIColor.yellow.textAttribute, for: .normal)
        tabBarItems.setTitleTextAttributes(UIColor.black.textAttribute, for: .selected)
    }
    
    func setupTableViews() {
        let tables = UITableView.appearance()
        tables.backgroundColor = .orange
        tables.sectionIndexColor = .green
        tables.sectionIndexBackgroundColor = .gray
        tables.tableFooterView = UIView()
        
        // Colors the front most view of the HeadFooterView
        UIView.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).backgroundColor = .yellow
        let cells = UITableViewCell.appearance()
        cells.backgroundColor = .purple
    }
    
    func setupCollectionViews() {
        let collections = UICollectionView.appearance()
        collections.backgroundColor = .clear
        collections.tintColor = .red
        let cells = UICollectionViewCell.appearance()
        cells.backgroundColor = .green
    }
    
    func setupSearchBars() {
        let searchBars = UISearchBar.appearance()
        searchBars.placeholder = "Search"
        searchBars.isTranslucent = false
        // Nav bar type: uses background color if set, otherwise uses nav bar barTint
        searchBars.backgroundColor = .green
        searchBars.barTintColor = .yellow
        searchBars.backgroundImage = nil
        // Cursor and cancel button color
        searchBars.tintColor = .purple
        // Background color of search field
        searchBars.fieldColor = .blue
        
        let cancelButton = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        cancelButton.setTitleTextAttributes(UIColor.black.textAttribute, for: .normal)
        UIView.appearance(whenContainedInInstancesOf: [UINavigationBar.self, UISearchBar.self])
            .backgroundColor = .green
    }
    
    func setupTextViews() {
        UITextView.appearance().backgroundColor = .clear
    }
}

private extension UIColor {
    
    var textAttribute: [NSAttributedString.Key : UIColor] {
        return [.foregroundColor : self]
    }
}
