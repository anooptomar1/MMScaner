//
//  ImageCaptureManager.swift
//  MMScaner
//
//  Created by Mei Ma on 10/5/17.
//  Copyright © 2017 Mei Ma. All rights reserved.
//

import Foundation
import AVFoundation
import CoreVideo
import CoreImage
import UIKit

class ImageCaptureManager: NSObject {

    //  the view to show the detected edges
    weak var edgeDetectionView: EdgeDetectionView?
    
    //  the image capture session
    private let captureSession: AVCaptureSession
    
    //  the quadrangle stablizer that stablize the quadrangle
    fileprivate let quadrangleFilter = QuadrangleFilter()
    
    /// the rectange detector that's used to detect the edge of the document
    //TODO: settings
    fileprivate let rectangleDetector = CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
    
    /// Initialize a ImageCaptureManager instance
    /// - parameter layer: the layer that shows the camera feeds
    /// - parameter edgeDetectionView: the view that shows the detected edge
    init?(layer: AVCaptureVideoPreviewLayer,
          edgeDetectionView: EdgeDetectionView) {
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let inputDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        let capturePhotoOutput = AVCapturePhotoOutput()
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: inputDevice),
        captureSession.canAddInput(deviceInput),
        captureSession.canAddOutput(capturePhotoOutput),
        captureSession.canAddOutput(videoOutput) else {
            debugPrint("Failed to add the input and output to capture session. Please run this on a real iOS device rather than an iOS simulator.")
            return nil
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        captureSession.addOutput(capturePhotoOutput)
        
        layer.session = captureSession
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
    
        self.captureSession = captureSession
        self.edgeDetectionView = edgeDetectionView
        
        super.init()
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video_output"))
    }
    
    /// Start showing the camera feeds
    func startSession() {
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if authorizationStatus == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {[weak self] (granted) in
                if granted {
                    self?.captureSession.startRunning()
                }
            })
        }
        else if authorizationStatus == .authorized {
            self.captureSession.startRunning()
        }
        else {
            //TODO: present error
        }
    }
    
    
    /// Stop showing the camera feeds
    func stopSession(){
        self.captureSession.stopRunning()
    }
    
}

/// AVCaptureVideoDataOutputSampleBufferDelegate
extension ImageCaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        let videoOutputImage = CIImage.init(cvPixelBuffer: pixelBuffer)
        guard let rectangeFeatures = self.rectangleDetector?.features(in: videoOutputImage) as? [CIRectangleFeature] else {
            return
        }
        guard let biggestRectangeFeature = rectangeFeatures.findBiggestRectangle() else {
            return
        }
        var quadrangle = biggestRectangeFeature.makeQuadrangle()
        quadrangle = self.quadrangleFilter.filteredQuadrangle(from: quadrangle)
        
        let landscapeImageSize = videoOutputImage.extent.size
        if quadrangle.isValid() {
            DispatchQueue.main.async { [weak self] in
                self?.edgeDetectionView?.showQuadrangle(quadrangle, inLandscapeImageWithSize: landscapeImageSize)
                self?.setEdgeDetectionView(self?.edgeDetectionView, hidden: false)
            }
        }
        else {
            DispatchQueue.main.async { [weak self] in
                self?.setEdgeDetectionView(self?.edgeDetectionView, hidden: true)
            }
        }
    }
    
    private func setEdgeDetectionView(_ edgeDetectionView: EdgeDetectionView?, hidden: Bool){
        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: { 
            edgeDetectionView?.alpha = hidden ? 0 : 1
        }, completion: nil)
    }
}
