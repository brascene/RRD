//
//  TestContent.swift
//  SwiftExample
//
//  Created by Dino Pelic on 5/9/18.
//  Copyright © 2018 Charcoal Design. All rights reserved.
//

import UIKit

protocol ArrowProtocol {
    func arrowClicked(proto: TestContent, expanded: Bool)
}

class TestContent: UIView {

    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var jobContentView: UIView!
    @IBOutlet weak var featuresLabel: UILabel!
    @IBOutlet weak var deleteJob: UIButton!
    @IBOutlet weak var jobImage: UIImageView!
    @IBOutlet weak var arrow: UIImageView!
    
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
        
        deleteJob.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        featuresLabel.sizeToFit()
        jobImage.roundCorners([.topLeft, .topRight], radius: 11.0)
        jobContentView.roundCorners([.bottomLeft, .bottomRight], radius: 11.0)
    }
    
    @objc func buttonClicked() {
        print("Button clicked")
    }
    
    @objc func arrowTapped() {
        if contentViewExpanded == false {
            delegate?.arrowClicked(proto: self, expanded: contentViewExpanded)
            contentViewExpanded = true
        } else {
            delegate?.arrowClicked(proto: self, expanded: contentViewExpanded)
            contentViewExpanded = false
        }
    }
}
