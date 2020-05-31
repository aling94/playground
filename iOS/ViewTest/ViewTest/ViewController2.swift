//
//  ViewController2.swift
//  ViewTest
//
//  Created by Alvin Ling on 5/27/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet var label: UILabel!
    @IBOutlet var positionSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        positionDidChange(positionSwitch)
    }
    
    @IBAction func tapped(_ sender: Any) {
        tableView.addToStack(CustomView.fromNib(), at: position)
    }
    
    @IBAction func remove(_ sender: Any) {
        guard let stackView = tableView![keyPath: position.path] as? UIStackView,
            let last = stackView.arrangedSubviews.last else { return }
        tableView.removeFromStack(last, at: position)
    }
    
    var position: UITableView.Position {
        return positionSwitch.isOn ? .header : .footer
    }
    
    @IBAction func positionDidChange(_ sender: UISwitch) {
        label.text = sender.isOn ? "Header" : "Footer"
    }
}

extension ViewController2: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        else { return UITableViewCell() }
        
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
}

@objc extension UITableView {
    
    @objc enum Position: Int {
        case header
        case footer
        
        var path: ReferenceWritableKeyPath<UITableView, UIView?> {
            switch self {
            case .header: return \.tableHeaderView
            case .footer: return \.tableFooterView
            }
        }
    }
    
    private func resizeView(at position: Position) {
        guard let view = self[keyPath: position.path] else { return }
        view.frame.size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self[keyPath: position.path] = view
    }

    @discardableResult
    func setupStackView(at position: Position) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = (position == .footer)
        self[keyPath: position.path] = stackView
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        resizeView(at: position)
        return stackView
    }
    
    func addToStack(_ view: UIView, at position: Position) {
        if self[keyPath: position.path] == nil {
            self[keyPath: position.path] = setupStackView(at: position)
        }
        guard let stackView = self[keyPath: position.path] as? UIStackView else { return }
        stackView.addArrangedSubview(view)
        resizeView(at: position)
    }
    
    func removeFromStack(_ view: UIView, at position: Position) {
        guard let stackView = self[keyPath: position.path] as? UIStackView,
            view.isDescendant(of: stackView) else { return }
        stackView.removeArrangedSubview(view)
        view.removeFromSuperview()
        resizeView(at: position)
    }
}
