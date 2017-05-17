//
//  CALayer+Extension.swift
//  MMScaner
//
//  Created by Mei Ma on 17/5/17.
//  Copyright © 2017 Mei Ma. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    // set the border color from UIColor, which can be used in xib user defined runtime attributes
    var borderColorFromUIColor: UIColor? {
        set{
            self.borderColor = newValue?.cgColor
        }
        get{
            guard let borderColor = self.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderColor)
        }
    }
    
    // set the border color from UIColor, which can be used in xib user defined runtime attributes
    var shadowColorFromUIColor: UIColor? {
        set{
            self.shadowColor = newValue?.cgColor
        }
        get{
            guard let shadowColor = self.shadowColor else {
                return nil
            }
            return UIColor(cgColor: shadowColor)
        }
    }
}
