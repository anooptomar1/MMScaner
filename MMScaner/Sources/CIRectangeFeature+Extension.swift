//
//  CIRectangeFeature+Extension.swift
//  MMScaner
//
//  Created by Mei Ma on 10/5/17.
//  Copyright © 2017 Mei Ma. All rights reserved.
//

import Foundation
import CoreImage

extension CIRectangleFeature {
    
    func makeQuadrangle() -> Quadrangle {
        return Quadrangle(topLeft: self.topLeft,
                    topRight: self.topRight,
                    bottomRight: self.bottomRight,
                    bottomLeft: self.bottomLeft)
    }
    
}

extension Array where Element: CIRectangleFeature {
    
    /// Find the biggest rectange feature within a list of rectange features
    /// - returns: the biggest rectange or nil if the array is empty
    func findBiggestRectangle() -> CIRectangleFeature? {
        guard self.count > 0 else {
            return nil
        }
        var halfPerimiterValue:CGFloat = 0
        var biggestRectangle: CIRectangleFeature?
        
        for rect in self {
            let p1 = rect.topLeft
            let p2 = rect.topRight
            let width = hypot(p1.x - p2.x, p1.y - p2.y)
            
            let p3 = rect.topLeft
            let p4 = rect.bottomLeft
            let height = hypot(p3.x - p4.x, p3.y - p4.y)
            
            let currentHalfPerimiterValue = height + width;
            if (halfPerimiterValue < currentHalfPerimiterValue) {
                halfPerimiterValue = currentHalfPerimiterValue
                biggestRectangle = rect
            }
        }
        
        return biggestRectangle
    }
    
}
