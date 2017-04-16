//
//  UIColor+ext.swift
//  TwitterClient
//
//  Created by Guoliang Wang on 4/15/17.
//  Copyright © 2017 com.rcholic. All rights reserved.
//

import UIKit

public extension UIColor {
    public convenience init(rgb: (r: CGFloat, g: CGFloat, b: CGFloat)) {
        self.init(red: rgb.r/255, green: rgb.g/255, blue: rgb.b/255, alpha: 1.0)
    }
}
