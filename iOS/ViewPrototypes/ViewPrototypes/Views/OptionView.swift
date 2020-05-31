//
//  OptionView.swift
//  ObserveTest
//
//  Created by Alvin Ling on 1/31/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

private typealias StateColors = (normal: UIColor?, selected: UIColor?)

@IBDesignable
class OptionView: UIControl {

    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var optionStack: UIStackView!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var optionLabelView: UIView!
    @IBOutlet weak var optionText: UILabel!
    @IBOutlet private weak var optionLabelWidth: NSLayoutConstraint!
    
    private var labelColors: StateColors = (nil, nil)
    private var textColors: StateColors = (nil, nil)
    
    override var isHighlighted: Bool {
        didSet {
            // Bypass the getter/setter that updates the StateColors properties
            optionLabel.textColor = isHighlighted ? labelColors.selected : labelColors.normal
            optionText.textColor = isHighlighted ? textColors.selected : textColors.normal
            optionLabelView.borderColor = labelColor
        }
    }
    
    // Programmatic init
    override init(frame: CGRect) {
      super.init(frame: frame)
      commonInit()
    }
    
    // XIB/Storyboard init
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        colorSetup()
    }
}

// MARK: - Private setup and helpers
private extension OptionView {
    func commonInit() {
        nibSetup()
        viewSetup()
    }
    
    func nibSetup() {
        let classType = type(of: self)
        Bundle(for: classType).loadNibNamed("\(classType)", owner: self)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func colorSetup() {
        labelColors = (labelColor, labelHighlight ?? labelColor?.withAlphaComponent(0.6))
        textColors = (textColor, textHighlight ?? textColor?.withAlphaComponent(0.6))
    }
    
    func viewSetup() {
        optionLabelView.cornerRadius = labelWidth / 2
        optionLabelView.borderWidth = 2
        subviews.forEach { $0.isUserInteractionEnabled = false }
    }
}


// MARK: - Interface Builder
extension OptionView {
    @IBInspectable var label: String? {
        get { return optionLabel.text }
        set { optionLabel.text = newValue }
    }
    
    @IBInspectable var text: String? {
        get { return optionText.text }
        set { optionText.text = newValue }
    }
    
    @IBInspectable var spacing: CGFloat {
        get { return optionStack.spacing }
        set { optionStack.spacing = newValue }
    }
    
    @IBInspectable var labelWidth: CGFloat {
        get { return optionLabelWidth.constant }
        set { optionLabelWidth.constant = newValue }
    }
    
    @IBInspectable var labelColor: UIColor? {
        get { return optionLabel.textColor }
        set {
            optionLabel.textColor = newValue
            optionLabelView.borderColor = newValue
            labelColors.normal = newValue
        }
    }
    
    @IBInspectable var textColor: UIColor? {
        get { return optionText.textColor }
        set {
            optionText.textColor = newValue
            textColors.normal = newValue
        }
    }

    @IBInspectable var labelHighlight: UIColor? {
        get { return labelColors.selected }
        set { labelColors.selected = newValue }
    }
    
    @IBInspectable var textHighlight: UIColor? {
        get { return textColors.selected }
        set { textColors.selected = newValue }
    }
}
