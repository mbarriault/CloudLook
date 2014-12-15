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

class ViewController: UIViewController, UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource {

    @IBOutlet weak var openinButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.openinButton.enabled = false
    }

    let UTIs: [String] = [kUTTypeText, kUTTypePlainText, kUTTypeUTF8PlainText, kUTTypeUTF16ExternalPlainText, kUTTypeUTF16PlainText, kUTTypeRTF, kUTTypeHTML, kUTTypeXML, kUTTypeSourceCode, kUTTypeCSource, kUTTypeObjectiveCSource, kUTTypeCPlusPlusSource, kUTTypeObjectiveCPlusPlusSource, kUTTypeCHeader, kUTTypeCPlusPlusHeader, kUTTypeJavaSource, kUTTypePDF, kUTTypeRTFD, kUTTypeFlatRTFD, kUTTypeTXNTextAndMultimediaData, kUTTypeWebArchive, kUTTypeImage, kUTTypeJPEG, kUTTypeJPEG2000, kUTTypeTIFF, kUTTypePICT, kUTTypeGIF, kUTTypePNG, kUTTypeQuickTimeImage, kUTTypeAppleICNS, kUTTypeBMP, kUTTypeICO, kUTTypeAudiovisualContent, kUTTypeMovie, kUTTypeVideo, kUTTypeAudio, kUTTypeQuickTimeMovie, kUTTypeMPEG, kUTTypeMPEG4, kUTTypeMP3, kUTTypeMPEG4Audio, kUTTypeAppleProtectedMPEG4Audio]

    @IBAction func showiCloudDrive(sender: UIBarButtonItem) {
        let picker = UIDocumentPickerViewController(documentTypes: self.UTIs, inMode: .Open)
        picker.delegate = self
        self.presentViewController(picker, animated: true) { () -> Void in
            // Do nothing
        }
    }

    var gotURL: NSURL?
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        // present document here
        self.gotURL = url
        self.openinButton.enabled = true

        let preview = QLPreviewController()
        preview.delegate = self
        preview.dataSource = self
        if let parentController = self.parentViewController as? UINavigationController {
            parentController.title = url.lastPathComponent
            self.addChildViewController(preview)
            preview.view.frame = self.view.frame
            self.view.addSubview(preview.view)
            preview.didMoveToParentViewController(self)
            parentController.navigationItem.rightBarButtonItem = self.openinButton!
        }
        else {
            self.presentViewController(preview, animated: true) { () -> Void in
                // do nothing
            }
        }
    }

    func documentPickerWasCancelled(controller: UIDocumentPickerViewController) {
        println("Cancelled!")
        if self.gotURL == nil {
            self.openinButton.enabled = false
        }
    }

    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        if let parentController = self.parentViewController as? UINavigationController {
            return parentController
        }
        else {
            return self
        }
    }

    func documentInteractionControllerWillBeginPreview(controller: UIDocumentInteractionController) {
        if let parentController = self.parentViewController as? UINavigationController {
            println(parentController.title)
            println(self.title)
        }
        else {
            println("Hrm, not navigation?")
        }
    }

    func previewController(controller: QLPreviewController!, previewItemAtIndex index: Int) -> QLPreviewItem! {
        return self.gotURL
    }

    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController!) -> Int {
        return 1
    }

    var preview: UIDocumentInteractionController? = nil
    @IBAction func openin(sender: UIBarButtonItem) {
        if let gotURL = self.gotURL {
            self.preview = UIDocumentInteractionController(URL: gotURL)
            if let preview = self.preview {
                preview.delegate = self
                preview.presentOptionsMenuFromBarButtonItem(sender, animated: true)
            }
        }
    }

}

