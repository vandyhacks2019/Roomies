//
//  UIViewController+StoryboardID.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/4/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit.UIViewController

extension UIViewController {
    class var storyboardID : String {
        return String(reflecting: self).components(separatedBy: ".").last!
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
