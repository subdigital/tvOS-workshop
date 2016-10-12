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
    var controllerViews: [GCController : GameControllerView] = [:]
    
    class GameControllerView : FocusableImageView {
        weak var controller: GCController?
        
        init(controller: GCController) {
            self.controller = controller
            super.init(frame: .zero)
        
            contentMode = .scaleAspectFit
            
            if controller.extendedGamepad != nil {
                image = #imageLiteral(resourceName: "controller")
            } else if controller.microGamepad != nil {
                image = #imageLiteral(resourceName: "tv-remote-landscape")
            }
        }
        
        func setFocused(_ focused: Bool) {
            backgroundColor = focused ? .lightGray : .clear
        }
        
        override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
            if context.nextFocusedView == self {
                coordinator.addCoordinatedAnimations({ 
                    self.setFocused(true)
                    }, completion: nil)
            } else if context.previouslyFocusedView == self {
                coordinator.addCoordinatedAnimations({
                    self.setFocused(false)
                    }, completion: nil)
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadControllers()
        NotificationCenter.default.addObserver(self, selector: #selector(GameControllersViewController.controllerDidConnect(_:)), name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GameControllersViewController.controllerDidDisconnect(_:)), name: .GCControllerDidDisconnect, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    func controllerDidConnect(_ notification: NSNotification) {
        print("Controller connected: \(notification.object)")
        add(controller: notification.object as! GCController)
    }
    
    func controllerDidDisconnect(_ notification: NSNotification) {
        print("Controller disconnected: \(notification.object)")
        remove(controller: notification.object as! GCController)
    }
    
    func add(controller: GCController) {
        let gcv = GameControllerView(controller: controller)
        let tap = UITapGestureRecognizer(target: self, action: #selector(GameControllersViewController.didTapController(_:)))
        gcv.addGestureRecognizer(tap)
        controllersStackView.addArrangedSubview(gcv)
        controllerViews[controller] = gcv
    }
    
    func remove(controller: GCController) {
        if let gcv = controllerViews[controller] {
            controllersStackView.removeArrangedSubview(gcv)
        }
    }

    func loadControllers() {
        for controller in GCController.controllers() {
            print("Found controller: \(controller.vendorName)")
            if controllerViews[controller] == nil {
                add(controller: controller)
            }
        }
    }


    @IBAction func discoverTapped(_ sender: UIButton) {
        isDiscovering = !isDiscovering
        if isDiscovering {
            print("Discovering game controllers...")
            GCController.startWirelessControllerDiscovery(completionHandler: {
                self.isDiscovering = false
                print("Done scanning for controllers")
            })
        } else {
            GCController.stopWirelessControllerDiscovery()
        }
    }

    func didTapController(_ gesture: UITapGestureRecognizer) {
        guard let gcv = gesture.view as? GameControllerView, let controller = gcv.controller else { return }
        let inspector = GameControllerInspectorViewController(controller: controller)
        present(inspector, animated: true, completion: nil)
    }
}
