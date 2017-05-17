//
//  ImagePreviewController.swift
//  MMScaner
//
//  Created by Mei Ma on 16/5/17.
//  Copyright © 2017 Mei Ma. All rights reserved.
//

import UIKit

class ImagePreviewController: UIViewController {

    let imageData: Data
    let detectedQuadrangle: Quadrangle?
    
    @IBOutlet var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageData: Data,
         detectedQuadrangle: Quadrangle?){
        self.imageData = imageData
        self.detectedQuadrangle = detectedQuadrangle
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.preview(imageData: self.imageData,
                     with: self.detectedQuadrangle)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper
    private func preview(imageData: Data,
                         with detectedQuadrangle: Quadrangle?){
        if let detectedQuadrangle = detectedQuadrangle {
            //  show the cropped image
            ImageEditManager.cut(quadrangle: detectedQuadrangle, outOfImageWith: imageData, completion: { (image) in
                self.populate(image: image)
            })
        }
        else {
            //  show the original image
            self.populate(image: UIImage(data: imageData))
        }
        
    }
    
    private func populate(image: UIImage?){
        guard let image = image else {
            return
        }
        //  adjust the frame of the image view
        self.adjust(imageView: self.imageView, forImageWith: image.size)
        
        //  set the image
        self.imageView.image = image
    }
    
    private func adjust(imageView: UIImageView, forImageWith size: CGSize){
        guard size != .zero else{
            return
        }
        
        //  remove the existing width height ratio layout constraint
        if let existingLayoutConstraint = imageView.constraints.first(where: { (layoutConstraint) -> Bool in
            return layoutConstraint.firstItem as? UIImageView == imageView &&
                layoutConstraint.firstAttribute == .width &&
                layoutConstraint.secondItem as? UIImageView == imageView &&
                layoutConstraint.secondAttribute == .height
        }){
            imageView.removeConstraint(existingLayoutConstraint)
        }
        let ratio = size.width / size.height
        
        //  add a new width height ratio layout constraint that matches the image size
        let newLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: ratio, constant: 1.0)
        imageView.addConstraint(newLayoutConstraint)
        imageView.superview?.layoutIfNeeded()
    }
}
