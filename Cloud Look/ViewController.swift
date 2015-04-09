//
//  ViewController.swift
//  Cloud Look
//
//  Created by Mike Barriault on 2014-12-14.
//  Copyright (c) 2014 Mike Barriault. All rights reserved.
//

import UIKit
import MobileCoreServices
import QuickLook

class ViewController: UIViewController {

    @IBOutlet weak var icloudButton: UIBarButtonItem!
    var picker: DocumentPicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker = DocumentPicker()
        self.showiCloudDrive(self.icloudButton)
    }

    @IBAction func showiCloudDrive(sender: UIBarButtonItem) {
        picker.pick(self)
    }
    
}

