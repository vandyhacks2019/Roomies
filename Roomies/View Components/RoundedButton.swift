//
//  RoundedButton.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/2/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable open class RoundedButton: UIButton {
    /// The control's corner radius.
    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    // MARK: - Initializers
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Life cycle
    open override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Build control
    open func customInit() {
        addBorder()
    }

    open func addBorder() {
        clipsToBounds = true

        layer.masksToBounds = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }
}
