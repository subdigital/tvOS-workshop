//
//  GameControllerInspectorViewController.swift
//  TVInput
//
//  Created by Ben Scheirman on 10/6/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit
import GameController

class GameControllerInspectorViewController : GCEventViewController {
    
    let controller: GCController
    
    init(controller: GCController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
        
        startObserving()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func startObserving() {
        controller.extendedGamepad?.leftThumbstick.valueChangedHandler = { axis, x, y in
            print("L Thumb: \(x)x\(y)")
        }
        
        controller.extendedGamepad?.rightThumbstick.valueChangedHandler = { axis, x, y in
            print("R Thumb: \(x)x\(y)")
        }

        controller.microGamepad?.dpad.valueChangedHandler = { axis, x, y in
            print("DPAD: \(axis) \(x)x\(y)")
        }
        
        controller.microGamepad?.buttonA.valueChangedHandler = buttonHandler("A")
        
        controller.controllerPausedHandler = { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func buttonHandler(_ label: String) -> GCControllerButtonValueChangedHandler {
        return { button, value, isPressed  in
            print("button: \(label)  value: \(value)   isPressed: \(isPressed)")
        }
    }
}
