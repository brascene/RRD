//
//  UIView+Extension.swift
//  SwiftExample
//
//  Created by Dino Pelic on 5/9/18.
//  Copyright © 2018 Charcoal Design. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first as! T
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.bounds = self.frame
        mask.position = self.center
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
