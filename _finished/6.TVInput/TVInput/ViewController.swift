//
//  ViewController.swift
//  TVInput
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let playPauseLocation = CGPoint(x: 892, y: 668)
    let menuLocation = CGPoint(x: 892, y: 410)
    let touchLocation = CGPoint(x: 960, y: 200)
    
    lazy var marker: UIView? = {
        let m = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        m.alpha = 0
        m.layer.cornerRadius = m.frame.size.width / 2
        m.backgroundColor = UIColor(red:0.53, green:0.14, blue:0.10, alpha:0.5)
        self.view.addSubview(m)
        return m
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
     
        let press = UITapGestureRecognizer(target: self, action: #selector(ViewController.playPauseTapped(gesture:)))
        press.allowedPressTypes = [
            NSNumber(integerLiteral: UIPressType.playPause.rawValue),
        ]
        view.addGestureRecognizer(press)
    }

    func playPauseTapped(gesture: UITapGestureRecognizer) {
        print("play pause tapped")
        animateMarker(to: playPauseLocation)
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            if press.type == .menu {
                animateMarker(to: menuLocation)
            }
            
            if press.type == .select {
                animateMarker(to: touchLocation)
            }
        }
    }
    
    private func animateMarker(to location: CGPoint) {
        UIView.animate(withDuration: 0.5, animations: {
            self.marker?.alpha = 1
            self.marker?.center = location
        }, completion: { completed in
                
                UIView.animate(withDuration: 0.5, delay: 1.0, options: [], animations: {
                    self.marker?.alpha = 0
                    }, completion: { (completed) in
                        
                })
        })
    }
}

