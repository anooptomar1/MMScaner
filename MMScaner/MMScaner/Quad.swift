//
//  Quad.swift
//  MMScaner
//
//  Created by Mei Ma on 10/5/17.
//  Copyright © 2017 Mei Ma. All rights reserved.
//

import Foundation
import QuartzCore

// The four points of the document edge
struct Quad {
    
    //  The top left point of the document edge
    var topLeft: CGPoint
    
    //  The top right point of the document edge
    var topRight: CGPoint
    
    //  The bottom left point of the document edge
    var bottomLeft: CGPoint
    
    //  The bottom right point of the document edge
    var bottomRight: CGPoint
    
    init(topLeft: CGPoint,
         topRight: CGPoint,
         bottomRight: CGPoint,
         bottomLeft: CGPoint){
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomRight = bottomRight
        self.bottomLeft = bottomLeft
    }
    
    
    /// Apply the transform to all its points
    /// - parameter transform: the transform to be applied
    mutating func applying(_ transform: CGAffineTransform) {
        self.topLeft = self.topLeft.applying(transform)
        self.topRight = self.topRight.applying(transform)
        self.bottomRight = self.bottomRight.applying(transform)
        self.bottomLeft = self.bottomLeft.applying(transform)
    }

    
}
