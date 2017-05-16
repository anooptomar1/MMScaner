//
//  ImageEditManager.swift
//  MMScaner
//
//  Created by Mei Ma on 16/5/17.
//  Copyright © 2017 Mei Ma. All rights reserved.
//

import Foundation
import UIKit

class ImageEditManager {
    
    class func cut(quadrangle: Quadrangle,
                   outOfImageWith imageData: Data,
                   completion: @escaping (UIImage?)->Void){
        DispatchQueue.global().async {
            var uiImage: UIImage? = nil
            if let ciImage = correctPerspective(for: CIImage(data: imageData), with: quadrangle) {
                uiImage = UIImage(ciImage: ciImage, scale: 1.0, orientation: UIImageOrientation.right)
            }
            DispatchQueue.main.async {
                completion(uiImage)
            }
        }
    }
    
    private class func correctPerspective(for image: CIImage?,
                                          with quadrangle: Quadrangle) -> CIImage? {
        let rectangleCoordinates = ["inputTopLeft":CIVector(cgPoint: quadrangle.topLeft),
                                    "inputTopRight":CIVector(cgPoint: quadrangle.topRight),
                                    "inputBottomLeft":CIVector(cgPoint: quadrangle.bottomLeft),
                                    "inputBottomRight":CIVector(cgPoint: quadrangle.bottomRight)]
        return image?.applyingFilter("CIPerspectiveCorrection", withInputParameters: rectangleCoordinates)
    }
    
}
