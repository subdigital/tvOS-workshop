//
//  FocusableImageView.swift
//  TVInput
//
//  Created by Ben Scheirman on 10/6/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class FocusableImageView : UIImageView {
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {
        }
    }

    override var canBecomeFocused: Bool {
        return true
    }
}
