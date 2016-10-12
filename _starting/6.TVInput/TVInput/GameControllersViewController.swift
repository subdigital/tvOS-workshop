//
//  GameControllersViewController.swift
//  TVInput
//
//  Created by Ben Scheirman on 10/6/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit
import GameController

class GameControllersViewController : UIViewController {

    var isDiscovering : Bool = false {
        didSet {
            if isDiscovering {
                activityIndicator.startAnimating()
                discoverButton.setTitle("Cancel", for: .normal)
            } else {
                activityIndicator.stopAnimating()
                discoverButton.setTitle("Discover Controllers", for: .normal)
            }
        }
    }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var discoverButton: UIButton!
    @IBOutlet weak var controllersStackView: UIStackView!

    
}
