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
    @IBOutlet weak var jobTitleLabel: UILabel!
    
    var contentViewExpanded: Bool = false
    let contentViewOffset: CGFloat = 40.0
    var delegate: ArrowProtocol?
    var singleJob: SingleJob?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteJob.backgroundColor = .deleteJobColor()
        featuresLabel.textColor = .radibaGrayText()
        setupTitleKernAndSpacing()
        
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
        
        featuresLabel.text = singleJob?.jobTags.joined(separator: ", ")
        jobTitleLabel.text = singleJob?.jobName
        setupTitleKernAndSpacing()
        
        let brojRedova = calculateNumberOfLines(in: featuresLabel)
        if brojRedova >= 3 {
            arrow.alpha = 1.0
            gestureView.isUserInteractionEnabled = true
        } else {
            arrow.alpha = 0.0
            gestureView.isUserInteractionEnabled = false
        }
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
    
    func calculateNumberOfLines(in label: UILabel) -> Int {
        let text = label.text! as NSString
        let rect = CGSize(width: label.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = text.boundingRect(with: rect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font : label.font], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / label.font.lineHeight))
    }
    
    func setupTitleKernAndSpacing() {
        let attributedString = NSMutableAttributedString(string: jobTitleLabel.text!)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: CGFloat(1.39125), range: NSRange(location: 0, length: attributedString.length))
        jobTitleLabel.attributedText = attributedString

        let pStyle = NSMutableParagraphStyle()
        pStyle.lineSpacing = 2
        let featuresString = NSMutableAttributedString(string: featuresLabel.text!)
        featuresString.addAttribute(NSAttributedStringKey.paragraphStyle, value: pStyle, range: NSRange(location: 0, length: attributedString.length))
        featuresLabel.attributedText = featuresString
    }
}
