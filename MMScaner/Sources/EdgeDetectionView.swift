//
//  EdgeDetectionView.swift
//  MMScaner
//
//  Created by Mei Ma on 10/5/17.
//  Copyright © 2017 Mei Ma. All rights reserved.
//

import UIKit
import QuartzCore

/// The view that display the detected edges of the document
class EdgeDetectionView: UIView {
    
    private var landscapeImageSize:CGSize?
    private var quadInImage:Quad?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let quadInImage = self.quadInImage else {
            return
        }
        guard let landscapeImageSize = self.landscapeImageSize else {
            return
        }
        guard let context  = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let quadInView = self.transformQuad(quadInImage, fromLandscapeImageWithSize: landscapeImageSize, toViewWithSize: rect.size)
        
        context.saveGState()
        
        //  draw the overlay
        //  the path of the bounds
        context.move(to: CGPoint(x: 0, y: 0))
        context.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        context.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        context.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        context.addLine(to: CGPoint(x: 0, y: 0))
        context.closePath()
        
        context.move(to: quadInView.topLeft)
        context.addLine(to: quadInView.bottomLeft)
        context.addLine(to: quadInView.bottomRight)
        context.addLine(to: quadInView.topRight)
        context.closePath()
        
        //TODO: appearance
        context.setFillColor(UIColor.black.withAlphaComponent(0.75).cgColor)
        context.fillPath(using: .evenOdd)
        context.restoreGState()
        
        // draw the lines
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(3.0)
        
        context.move(to: quadInView.topLeft)
        context.addLine(to: quadInView.bottomLeft)
        context.addLine(to: quadInView.bottomRight)
        context.addLine(to: quadInView.topRight)
        context.closePath()
        context.strokePath()
        
    }
    
    func showEdgesWithQuad(_ quad: Quad,
                           landscapeImageSize: CGSize){
        self.quadInImage = quad
        self.landscapeImageSize = landscapeImageSize
        self.setNeedsDisplay()
    }
    
    private func transformQuad(_ quad:Quad,
                               fromLandscapeImageWithSize landscapeImageSize:CGSize,
                               toViewWithSize viewSize:CGSize) -> Quad{
        var result = quad
        
        let portraitImageSize = CGSize.init(width: landscapeImageSize.height, height: landscapeImageSize.width)
        var transform = self.transform(forSize: portraitImageSize, aspectFillIntoSize: viewSize)
        result.applying(transform)
        
        let imageSize = landscapeImageSize.applying(transform)
        transform = self.flipCooridnateSystem(withHeight: imageSize.height)
        result.applying(transform)
        
        transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        result.applying(transform)
        
        var imageBounds = CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        imageBounds = imageBounds.applying(transform)
        
        transform = self.translate(fromCenterOfRect: imageBounds, toCenterOfRect: CGRect.init(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
        result.applying(transform)
        
        return result
    }
    
    private func transform(forSize fromSize: CGSize, aspectFillIntoSize toSize: CGSize) -> CGAffineTransform {
        let scale = max(toSize.width / fromSize.width, toSize.height/fromSize.height)
        return CGAffineTransform.init(scaleX: scale, y: scale)
    }
    
    private func flipCooridnateSystem(withHeight height: CGFloat) -> CGAffineTransform {
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -height)
        return transform
    }
    
    private func translate(fromCenterOfRect fromRect: CGRect, toCenterOfRect toRect: CGRect) -> CGAffineTransform {
        let translate = CGPoint(x: toRect.midX - fromRect.midX, y: toRect.midY - fromRect.midY)
        return CGAffineTransform(translationX: translate.x, y: translate.y)
    }
    
}
