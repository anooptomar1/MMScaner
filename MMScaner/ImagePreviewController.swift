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
        if let detectedQuadrangle = self.detectedQuadrangle {
            ImageEditManager.cut(quadrangle: detectedQuadrangle, outOfImageWith: self.imageData, completion: { (image) in
                self.imageView.image = image
            })
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
}
