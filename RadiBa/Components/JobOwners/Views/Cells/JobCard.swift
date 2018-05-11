//
//  TestContent.swift
//  SwiftExample
//
//  Created by Dino Pelic on 5/9/18.
//  Copyright © 2018 Charcoal Design. All rights reserved.
//

import UIKit

protocol ArrowProtocol {
    func arrowClicked(expanded: Bool)
}

class JobCard: UIView {

    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var jobContentView: UIView!
    @IBOutlet weak var featuresLabel: UILabel!
    @IBOutlet weak var deleteJob: UIButton!
    @IBOutlet weak var jobImage: UIImageView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var gestureView: UIView!
    
    var contentViewExpanded: Bool = false
    let contentViewOffset: CGFloat = 40.0
    var delegate: ArrowProtocol?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteJob.backgroundColor = .deleteJobColor()
        featuresLabel.textColor = .radibaGrayText()
        
        let arrowRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.arrowTapped))
        arrow.isUserInteractionEnabled = true
        arrow.addGestureRecognizer(arrowRecognizer)
        featuresLabel.isUserInteractionEnabled = true
        featuresLabel.addGestureRecognizer(arrowRecognizer)
        gestureView.isUserInteractionEnabled = true
        gestureView.addGestureRecognizer(arrowRecognizer)
    }
    
    override func layoutSubviews() {
        featuresLabel.sizeToFit()
        jobImage.roundCorners([.topLeft, .topRight], radius: 11.0)
        jobContentView.roundCorners([.bottomLeft, .bottomRight], radius: 11.0)
    }
    
    @objc func arrowTapped() {
        if contentViewExpanded == false {
            delegate?.arrowClicked(expanded: contentViewExpanded)
            contentViewExpanded = true
        } else {
            delegate?.arrowClicked(expanded: contentViewExpanded)
            contentViewExpanded = false
        }
    }
}
