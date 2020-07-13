//
//  ViewController3.swift
//  ViewTest
//
//  Created by Alvin Ling on 6/27/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {

    @IBOutlet var button: AlignedIconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.setTitle(buttonTitle, for: .normal)
        button.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        button.rightAlignedIcon(left: 15, right: 15, space: 10)
        button.centeredTitleRightIcon(left: 0, right: 15, space: 10)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

extension UIImage {
    
    var template: UIImage {
        withRenderingMode(.alwaysTemplate)
    }
}

private let buttonTitle = "hello"

extension UIButton {
    
    func rightAlignedIcon(left: CGFloat, right: CGFloat, space: CGFloat, lines: Int = 1) {
        guard let imageWidth = imageView?.frame.width else { return }
        let imageInset = frame.width - imageWidth - left - right
        contentHorizontalAlignment = .left
        titleLabel?.lineBreakMode = .byTruncatingTail
        titleLabel?.numberOfLines = lines
        titleEdgeInsets = .init(-imageWidth, imageWidth)
        imageEdgeInsets = .init(imageInset, -imageInset + space)
        contentEdgeInsets = .init(left, right)
    }
    
    func centeredTitleRightIcon(left: CGFloat, right: CGFloat, space: CGFloat) {
        guard let imageWidth = imageView?.frame.width else { return }
        titleLabel?.lineBreakMode = .byTruncatingTail
        let space = space / 2 + right
        let imageInset = frame.width - imageWidth - right
        imageEdgeInsets =
            .init(top: 0, left: imageInset - space, bottom: 0, right: -space)
        titleEdgeInsets = .init(top: 0, left: -imageWidth/2, bottom: 0, right: imageWidth/2)
        contentEdgeInsets = .init(top: 0, left: space, bottom: 0, right: space)
    }
}

private extension UIEdgeInsets {
    
    init(_ left: CGFloat, _ right: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: right)
    }
}
