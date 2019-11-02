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
    /// cornerRadius doesn't work for this control. It's strictly set to frame.size.height*0.5
    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
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

        setCornerRadius()
    }

    // MARK: - Build control
    open func customInit() {
        addBorder()
    }

    open func addBorder() {
        setCornerRadius()
        clipsToBounds = true

        layer.masksToBounds = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }

    private func setCornerRadius() {
        layer.cornerRadius = frame.size.height * 0.5
    }
}
