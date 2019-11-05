//
//  AppStoryboard.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/4/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit.UIStoryboard

enum AppStoryboard: String {
    case Main = "Main"
    case PreLogin = "PreLogin"
    case Setup = "Setup"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T : UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
    
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard")
        }

        return scene
    }

    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}
