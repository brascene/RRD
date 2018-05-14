//
//  PhonesTableViewCell.swift
//  SwiftExample
//
//  Created by Dino Pelic on 5/9/18.
//  Copyright © 2018 Charcoal Design. All rights reserved.
//

import UIKit

class PhonesTableViewCell: UITableViewCell {
    @IBOutlet weak var tableCellShadowView: UIView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneCallImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRadius()
        setupShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupTable(with user: AppliedUser) {
        phoneLabel.text = user.phoneNumber
        nameLabel.text = user.userName
        if user.isRated {
            phoneCallImage.alpha = 0.0
            starView.alpha = 1.0
            if starView.subviews.count == 0 {
                showStarView(with: user.ratingNumber)
            }
        } else {
            phoneCallImage.alpha = 1.0
            starView.alpha = 0.0
        }
    }
    
    func showStarView(with stars: Int) {
        let starViewOrigin = starView.frame.origin
        for v in starView.subviews {
            v.removeFromSuperview()
        }
        for i in 0 ... 4 {
            let singleStar: UIImageView = UIImageView()
            singleStar.translatesAutoresizingMaskIntoConstraints = true
            singleStar.frame = CGRect(origin: starViewOrigin, size: CGSize(width: 12.5, height: 11.5))
            
            if i < stars {
                singleStar.image = #imageLiteral(resourceName: "star")
            } else {
                singleStar.image = #imageLiteral(resourceName: "grayStar")
            }
            
            let newOriginX = starViewOrigin.x + (CGFloat(i) * singleStar.frame.width + CGFloat(2))
            let singleStarFrame: CGRect = CGRect(x: newOriginX, y: starViewOrigin.y, width: singleStar.frame.width, height: singleStar.frame.height)
            singleStar.frame = singleStarFrame
            
            starView.addSubview(singleStar)
            self.contentView.addSubview(starView)
        }
     }
    
    func setupShadow() {
        tableCellShadowView!.layer.shadowOffset = CGSize(width: 0, height: 10)
        tableCellShadowView!.layer.shadowColor = UIColor(rgb: 0xa6adcc, alphaVal: 1.0).cgColor
        tableCellShadowView!.layer.shadowRadius = 8.0
        tableCellShadowView!.layer.shadowOpacity = 0.4
        tableCellShadowView!.layer.masksToBounds = false;
        tableCellShadowView!.clipsToBounds = false;
    }
    
    func setupRadius() {
        tableCellShadowView.layer.cornerRadius = 31.0
        if #available(iOS 11.0, *) {
            tableCellShadowView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            tableCellShadowView.roundCorners([.topLeft, .bottomLeft, .topRight, .bottomRight], radius: tableCellShadowView.frame.size.height / 2)
        }
    }
}
