//
//  ViewController.swift
//  MMScaner
//
//  Created by Mei Ma on 10/5/17.
//  Copyright © 2017 Mei Ma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startScanning() {
        let viewController = CameraViewController()
        self.present(viewController, animated: true, completion: nil)
    }
    
}

