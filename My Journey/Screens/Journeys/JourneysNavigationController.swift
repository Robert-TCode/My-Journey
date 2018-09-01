//
//  JourneysNavigationController.swift
//  My Journey
//
//  Created by Victor Stanescu on 01/09/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import UIKit

class JourneysNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBar.isHidden = true
    }
}
