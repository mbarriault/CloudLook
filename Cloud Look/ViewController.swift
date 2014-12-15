//
//  ViewController.swift
//  Cloud Look
//
//  Created by Mike Barriault on 2014-12-14.
//  Copyright (c) 2014 Mike Barriault. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.previewButton.enabled = false
    }

    let UTIs: [String] = [kUTTypeText, kUTTypePlainText, kUTTypeUTF8PlainText, kUTTypeUTF16ExternalPlainText, kUTTypeUTF16PlainText, kUTTypeRTF, kUTTypeHTML, kUTTypeXML, kUTTypeSourceCode, kUTTypeCSource, kUTTypeObjectiveCSource, kUTTypeCPlusPlusSource, kUTTypeObjectiveCPlusPlusSource, kUTTypeCHeader, kUTTypeCPlusPlusHeader, kUTTypeJavaSource, kUTTypePDF, kUTTypeRTFD, kUTTypeFlatRTFD, kUTTypeTXNTextAndMultimediaData, kUTTypeWebArchive, kUTTypeImage, kUTTypeJPEG, kUTTypeJPEG2000, kUTTypeTIFF, kUTTypePICT, kUTTypeGIF, kUTTypePNG, kUTTypeQuickTimeImage, kUTTypeAppleICNS, kUTTypeBMP, kUTTypeICO, kUTTypeAudiovisualContent, kUTTypeMovie, kUTTypeVideo, kUTTypeAudio, kUTTypeQuickTimeMovie, kUTTypeMPEG, kUTTypeMPEG4, kUTTypeMP3, kUTTypeMPEG4Audio, kUTTypeAppleProtectedMPEG4Audio]

    @IBOutlet weak var previewButton: UIBarButtonItem!

    @IBAction func showiCloudDrive(sender: UIBarButtonItem) {
        let picker = UIDocumentPickerViewController(documentTypes: self.UTIs, inMode: .Open)
        picker.delegate = self
        self.presentViewController(picker, animated: true) { () -> Void in
            // Do nothing
        }
    }

    var gotURL: NSURL?
    @IBOutlet weak var fileLabel: UILabel!
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        // present document here
        self.gotURL = url
        self.previewButton.enabled = true
        self.fileLabel.text = url.description
    }

    func documentPickerWasCancelled(controller: UIDocumentPickerViewController) {
        println("Cancelled!")
        self.previewButton.enabled = false
    }

    @IBOutlet weak var documentView: UIView!
    @IBAction func previewDocument(sender: AnyObject) {
        if let gotURL = self.gotURL {
            let preview = UIDocumentInteractionController(URL: gotURL)
            preview.delegate = self
            preview.presentPreviewAnimated(true)
        }
    }

    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

    func documentInteractionControllerViewForPreview(controller: UIDocumentInteractionController) -> UIView? {
        return self.documentView
    }

}

