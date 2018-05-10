//
//  UIColor+Extension.swift
//  SwiftExample
//
//  Created by Dino Pelic on 5/9/18.
//  Copyright © 2018 Charcoal Design. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgb: UInt, alphaVal: CGFloat = 1) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: alphaVal
        )
    }
    
    class func deleteJobColor() -> UIColor {
        return UIColor(rgb: 0xee7157, alphaVal: 1.0)
    }
    
    class func addJobColor() -> UIColor {
        return UIColor(rgb: 0xff9f5b, alphaVal: 1.0)
    }
    
    class func radibaGrayText() -> UIColor {
        return UIColor(rgb: 0xabacac, alphaVal: 1.0)
    }
}
