//
//  MovieCell.swift
//  MovieBrowser
//
//  Created by Ben Scheirman on 10/5/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class MovieCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var labelSpacingConstraint: NSLayoutConstraint!
    
    var task: URLSessionDataTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()

        task?.cancel()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    func loadImage(withURL url: URL) {
        task?.cancel()
        
        task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                if let http = response as? HTTPURLResponse {
                    print("HTTP \(http.statusCode)")
                }
                print("data was nil or not an image...")
            }
        }
        task?.resume()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({ 
//                self.titleLabel.transform = self.titleLabel.transform.scaledBy(x: 1.2, y: 1.2)
//                self.titleLabel.shadowColor = .black
//                self.titleLabel.shadowOffset = CGSize(width: 0, height: 3)
                self.labelSpacingConstraint.constant = 68
                self.setNeedsLayout()
                }, completion: nil)
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({
//                self.titleLabel.transform = CGAffineTransform.identity
//                self.titleLabel.shadowColor = .clear
//                self.titleLabel.shadowOffset = CGSize(width: 0, height: 0)
                self.labelSpacingConstraint.constant = 28
                self.setNeedsLayout()
                }, completion: nil)
        }
    }
}
