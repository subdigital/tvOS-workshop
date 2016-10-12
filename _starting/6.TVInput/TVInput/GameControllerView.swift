//
//  GameControllerView.swift
//  TVInput
//
//  Created by Ben Scheirman on 10/11/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit
import GameController

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
