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

class ImageCaptureManager {

    //  the image capture session
    private let captureSession: AVCaptureSession
    
    /// Initialize a ImageCaptureManager instance
    init?(layer: AVCaptureVideoPreviewLayer) {
        
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
