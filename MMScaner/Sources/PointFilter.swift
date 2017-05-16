//
//  PointFilter.swift
//  MMScaner
//
//  Created by LEAP Legal Software on 11/5/17.
//  Copyright © 2017 Mei Ma. All rights reserved.
//

import Foundation
import QuartzCore

class PointFilter {
    
    private var centroid = CGPoint.zero
    private let distanceThreshold: CGFloat = 39.0
    private let hitCountThreshold: CGFloat = 2
    private let missCountThreshold: CGFloat = 5
    private var hitCount: CGFloat = 0
    private var missCount: CGFloat = 0
    
    func filteredPoint(from point: CGPoint) -> CGPoint {
        if point.equalTo(.zero){
            return .zero
        }
        
        if self.centroid.equalTo(.zero){
            self.centroid = point
            return .zero
        }
        
        let distance = hypot(point.x - self.centroid.x, point.y - self.centroid.y)
        if (distance <= self.distanceThreshold) {
            if (self.hitCount < self.hitCountThreshold){
                self.hitCount += 1
            }
            if (self.missCount > 0){
                self.missCount -= 1
            }
            self.centroid = CGPoint(x: (self.centroid.x * self.hitCount + point.x) / (self.hitCount + 1), y: (self.centroid.y * self.hitCount + point.y) / (self.hitCount + 1))
        }
        else {
            if (self.missCount < self.missCountThreshold){
                self.missCount += 1
            }
            if (self.hitCount > 0){
                self.hitCount -= 1
            }
        }
        
        if self.missCount >= self.missCountThreshold {
            self.hitCount = 0
            self.centroid = point
            return .zero
        }
        else if self.hitCount >= self.hitCountThreshold {
            self.missCount = 0
            return self.centroid
        }
        else {
            return .zero
        }
    }
}
