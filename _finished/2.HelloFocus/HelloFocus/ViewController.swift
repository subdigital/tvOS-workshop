//
//  ViewController.swift
//  HelloFocus
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var focusGuide: UIFocusGuide!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        focusGuide = UIFocusGuide()
        view.addLayoutGuide(focusGuide)
        
        NSLayoutConstraint.activate([
            focusGuide.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            focusGuide.centerYAnchor.constraint(equalTo: button3.centerYAnchor),
            focusGuide.widthAnchor.constraint(equalTo: button.widthAnchor),
            focusGuide.heightAnchor.constraint(equalTo: button3.heightAnchor)
        ])
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print("didUpdateFocus")
        
        guard let nextFocusedView = context.nextFocusedView else { return }
        
        switch nextFocusedView {
        case button:
            focusGuide.preferredFocusEnvironments = [button3]
        case button3:
            focusGuide.preferredFocusEnvironments = [button]
        default:
            focusGuide.preferredFocusEnvironments = []
        }
    }
}

