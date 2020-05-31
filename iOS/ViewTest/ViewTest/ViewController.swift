//
//  ViewController.swift
//  ViewTest
//
//  Created by Alvin Ling on 4/4/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

let CHAR_LIMIT = 50

class ViewController: UIViewController {
    
    @IBOutlet private var textbox: UITextView!
    @IBOutlet private var counter: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        textViewDidChange(textbox)
    }
    
    

}

extension ViewController: UITextViewDelegate {
    
    private func isWithinLimit(_ textView: UITextView, range: NSRange, text: String) -> Bool {
        return textView.text.count - range.length + text.count <= CHAR_LIMIT
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard !isWithinLimit(textView, range: range, text: text) else { return true }
        
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        counter.text = "\(textView.text.count)/\(CHAR_LIMIT)"
    }
}
