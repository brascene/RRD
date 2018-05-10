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
