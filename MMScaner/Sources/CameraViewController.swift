//
//  CameraViewController.swift
//  MMScaner
//
//  Created by Mei Ma on 10/5/17.
//  Copyright © 2017 Mei Ma. All rights reserved.
//

import UIKit
import AVFoundation

/// The view controller that display the camera feeds and shows the edges of the document if detected.
class CameraViewController: UIViewController {

    @IBOutlet var edgeDetectionView: EdgeDetectionView!
    
    /// the image capture manager
    private var imageCaptureManager: ImageCaptureManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let captureVideoPreviewLayer = self.view.layer as? AVCaptureVideoPreviewLayer {
            self.imageCaptureManager = ImageCaptureManager(layer: captureVideoPreviewLayer,
                                                           edgeDetectionView:self.edgeDetectionView)
        }
        else {
            debugPrint("The layer of the root view must be a subclass of AVCaptureVideoPreviewLayer")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.imageCaptureManager?.startSession()
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }

}
