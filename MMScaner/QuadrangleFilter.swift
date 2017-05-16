//
//  QuadrangleFilter.swift
//  MMScaner
//
//  Created by LEAP Legal Software on 11/5/17.
//  Copyright © 2017 Mei Ma. All rights reserved.
//

import Foundation
import QuartzCore

class QuadrangleFilter {
    
    private let topLeftFilter = PointFilter()
    private let topRightFilter = PointFilter()
    private let bottomRightFilter = PointFilter()
    private let bottomLeftFilter = PointFilter()
    
    func filteredQuadrangle(from quadrangle: Quadrangle) -> Quadrangle {
        
        let topLeft = self.topLeftFilter.filteredPoint(from: quadrangle.topLeft)
        let topRight = self.topRightFilter.filteredPoint(from: quadrangle.topRight)
        let bottomRight = self.bottomRightFilter.filteredPoint(from: quadrangle.bottomRight)
        let bottomLeft = self.bottomLeftFilter.filteredPoint(from: quadrangle.bottomLeft)
        let filteredQuadrangle = Quadrangle(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        if filteredQuadrangle.isValid() {
            return filteredQuadrangle
        }
        else {
            return Quadrangle(topLeft: .zero, topRight: .zero, bottomRight: .zero, bottomLeft: .zero)
        }
        
    }
}
