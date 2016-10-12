//
//  ViewController.swift
//  HelloTV
//
//  Created by Ben Scheirman on 9/30/16.
//  Copyright © 2016 Fickle Bits, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!

    let fortunes = [
        "You will learn a lot this week",
        "You will soon meet a new friend",
        "Your advice will be sought out by a colleage"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        label.alpha = 0
    }

    @IBAction func getFortunePressed(_ sender: AnyObject) {
        label.text = randomQuote()
        UIView.animate(withDuration: 1) {
            self.label.alpha = 1
        }
    }

    func randomQuote() -> String {
        let index = Int(arc4random()) % fortunes.count
        return fortunes[index]
    }
}

