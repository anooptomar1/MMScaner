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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.imageCaptureManager?.startSession()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.imageCaptureManager?.stopSession()
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func capture() {
        self.showImageCaptureLoadingView()
        self.imageCaptureManager?.capture(completion: {[weak self] (imageData, detectedQuadrangle) in
            self?.hideImageCaptureLoadingView()
            self?.previewImage(with: imageData, detectedQuadrangle: detectedQuadrangle)
        })
    }

    private func showImageCaptureLoadingView(){
        //TODO
        self.view.isUserInteractionEnabled = false
    }
    
    private func hideImageCaptureLoadingView(){
        //TODO
        self.view.isUserInteractionEnabled = true
    }
    
    private func previewImage(with imageData: Data?,
                              detectedQuadrangle: Quadrangle?){
        guard let imageData = imageData else {
            //TODO: display error
            return
        }
        let viewController = ImagePreviewController(imageData: imageData, detectedQuadrangle: detectedQuadrangle)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
