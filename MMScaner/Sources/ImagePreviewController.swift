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
    var imageViewWidthHeightRatioLayoutConstraint: NSLayoutConstraint?
    
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
        
        if let detectedQuadrangle = self.detectedQuadrangle {
            ImageEditManager.cut(quadrangle: detectedQuadrangle, outOfImageWith: self.imageData, completion: { (image) in
                self.populate(image: image)
            })
        }
        else {
            self.populate(image: UIImage(data: self.imageData))
        }
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
    private func adjust(imageView: UIImageView, forImageWith size: CGSize){
        guard size != .zero else{
            return
        }
        if let existingLayoutConstraint = imageView.constraints.first(where: { (layoutConstraint) -> Bool in
            return layoutConstraint.firstItem as? UIImageView == imageView &&
                layoutConstraint.firstAttribute == .width &&
                layoutConstraint.secondItem as? UIImageView == imageView &&
                layoutConstraint.secondAttribute == .height
        }){
            imageView.removeConstraint(existingLayoutConstraint)
        }
        let ratio = size.width / size.height
        let newLayoutConstraint = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: ratio, constant: 1.0)
        imageView.addConstraint(newLayoutConstraint)
        imageView.superview?.layoutIfNeeded()
    }
    
    private func populate(image: UIImage?){
        guard let image = image else {
            return
        }
        
        self.adjust(imageView: self.imageView, forImageWith: image.size)
        self.imageView.image = image
    }
}
