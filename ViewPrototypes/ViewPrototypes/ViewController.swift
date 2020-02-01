//
//  ViewController.swift
//  ViewPrototypes
//
//  Created by Alvin Ling on 2/1/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var optionOne: OptionView!
    @IBOutlet weak var optionTwo: OptionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func optionOne(_ sender: Any) {
        print("You are clicking Option One")
    }
    @IBAction func optionTwo(_ sender: Any) {
        print("You are clicking Option Two")
    }
}
