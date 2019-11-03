//
//  ProfileViewController.swift
//  Roomies
//
//  Created by Keaton Burleson on 11/3/19.
//  Copyright © 2019 Keaton Burleson. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var profileImageButton: UIButton!
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        
    }
}
