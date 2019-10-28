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
        styleNavBars()
        styleTabBars()
        styleTextViews()
        styleTabBars()
        styleCollectionViews()
        styleTableViews()
        styleSearchBars()
    }
    
    private func styleNavBars() {
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
    
    private func styleTabBars() {
        let tabBars = UITabBar.appearance()
        // Layer order from bottom-most: backgroundColor, barTint, backgroundImage
        tabBars.backgroundColor = .red
        tabBars.barTintColor = .orange
        tabBars.backgroundImage = UIImage(color: .blue)
        // Icon tints
        tabBars.tintColor = .white
        tabBars.unselectedItemTintColor = .green
        tabBars.isTranslucent = false
        
        let tabBarItems = UITabBarItem.appearance()
        // unselectedItemTintColor seems to take priority over .normal titleTextAttributes
        tabBarItems.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.yellow], for: .normal)
        tabBarItems.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
    }
    
    private func styleTableViews() {
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
    
    private func styleCollectionViews() {
        let collections = UICollectionView.appearance()
        collections.backgroundColor = .clear
        collections.tintColor = .red
        let cells = UICollectionViewCell.appearance()
        cells.backgroundColor = .green
    }
    
    private func styleSearchBars() {
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
        cancelButton.setTitleTextAttributes(textColor(.black), for: .normal)
        UIView.appearance(whenContainedInInstancesOf: [UINavigationBar.self, UISearchBar.self])
            .backgroundColor = .green
    }
    
    private func styleTextViews() {
        UITextView.appearance().backgroundColor = .clear
    }
}

private func textColor(_ color: UIColor) -> [NSAttributedString.Key : Any] {
    return [NSAttributedString.Key.foregroundColor: color]
}
