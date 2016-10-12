//
//  ViewController.swift
//  HelloTables
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class ButtonContainerView: UIView {
    @IBOutlet weak var button: UIButton!
    
//    override var canBecomeFocused: Bool {
//        return true
//    }
//    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [button]
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        print(context)
        print(context.nextFocusedView)
        
        if let next = context.nextFocusedView, next == button {
            coordinator.addCoordinatedAnimations({ 
                self.button.backgroundColor = .red
                self.button.transform = self.button.transform.rotated(by: .pi/2)
                }, completion: nil)
        } else if let previous = context.previouslyFocusedView, previous == button {
            coordinator.addCoordinatedAnimations({ 
                self.button.backgroundColor = nil
                }, completion: nil)
        }
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonContainer: ButtonContainerView!
    
    var focusGuide: UIFocusGuide!
    var lastHighlightedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        title = "Table View Example"
        tableView.remembersLastFocusedIndexPath = true
        
        
        
        focusGuide = UIFocusGuide()
        buttonContainer.addLayoutGuide(focusGuide)

        NSLayoutConstraint.activate([
            focusGuide.widthAnchor.constraint(equalToConstant: 10),
            focusGuide.heightAnchor.constraint(equalTo: buttonContainer.heightAnchor),
            focusGuide.leftAnchor.constraint(equalTo: buttonContainer.leftAnchor),
            focusGuide.topAnchor.constraint(equalTo: buttonContainer.topAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "Cell \(indexPath.row + 1)"
        return cell
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard let nextFocusedView = context.nextFocusedView else { return }
        switch nextFocusedView {
        case buttonContainer.button:
            focusGuide.preferredFocusEnvironments = [tableView]
        default:
            focusGuide.preferredFocusEnvironments = [buttonContainer.button]
        }
    }
}

