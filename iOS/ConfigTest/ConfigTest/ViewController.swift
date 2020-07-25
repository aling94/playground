//
//  ViewController.swift
//  ConfigTest
//
//  Created by Alvin Ling on 7/13/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = Bundle.main.appVersion
    }


}

