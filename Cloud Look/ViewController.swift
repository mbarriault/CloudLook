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

class ViewController: UIViewController, UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource, NSFilePresenter {

    @IBOutlet weak var icloudButton: UIBarButtonItem!
    @IBOutlet weak var openinButton: UIBarButtonItem!
    
    var presentedItemURL: NSURL? = nil
    var presentedItemOperationQueue = NSOperationQueue.mainQueue()
    var coordinator: NSFileCoordinator! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.openinButton.enabled = false
        self.coordinator = NSFileCoordinator(filePresenter: self)
        
        if self.presentedItemURL == nil {
            self.showiCloudDrive(self.icloudButton)
        }
    }

    let UTIs = [kUTTypeText, kUTTypePlainText, kUTTypeUTF8PlainText, kUTTypeUTF16ExternalPlainText, kUTTypeUTF16PlainText, kUTTypeRTF, kUTTypeHTML, kUTTypeXML, kUTTypeSourceCode, kUTTypeCSource, kUTTypeObjectiveCSource, kUTTypeCPlusPlusSource, kUTTypeObjectiveCPlusPlusSource, kUTTypeCHeader, kUTTypeCPlusPlusHeader, kUTTypeJavaSource, kUTTypePDF, kUTTypeRTFD, kUTTypeFlatRTFD, kUTTypeTXNTextAndMultimediaData, kUTTypeWebArchive, kUTTypeImage, kUTTypeJPEG, kUTTypeJPEG2000, kUTTypeTIFF, kUTTypePICT, kUTTypeGIF, kUTTypePNG, kUTTypeQuickTimeImage, kUTTypeAppleICNS, kUTTypeBMP, kUTTypeICO, kUTTypeAudiovisualContent, kUTTypeMovie, kUTTypeVideo, kUTTypeAudio, kUTTypeQuickTimeMovie, kUTTypeMPEG, kUTTypeMPEG4, kUTTypeMP3, kUTTypeMPEG4Audio, kUTTypeAppleProtectedMPEG4Audio, kUTTypePackage]

    @IBAction func showiCloudDrive(sender: UIBarButtonItem) {
        let picker = UIDocumentPickerViewController(documentTypes: self.UTIs, inMode: .Open)
        picker.delegate = self
        self.presentViewController(picker, animated: true) { () -> Void in
            // Do nothing
        }
    }
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        // present document here
        if self.presentedItemURL != nil {
            self.presentedItemURL!.stopAccessingSecurityScopedResource()
        }
        self.presentedItemURL = url
        self.openinButton.enabled = true
        if !url.startAccessingSecurityScopedResource() {
            let alert = UIAlertController(title: "Error", message: "Can't open file \(url.lastPathComponent)", preferredStyle: .Alert)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
//        NSFileCoordinator.addFilePresenter(self)
        
        coordinator.coordinateReadingItemAtURL(url, options: .WithoutChanges, error: nil) { (url: NSURL!) -> Void in
            
        }

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
//        NSFileCoordinator.removeFilePresenter(self)
        if let url = self.presentedItemURL {
            url.stopAccessingSecurityScopedResource()
        }
        else {
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
        return self.presentedItemURL
    }

    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController!) -> Int {
        return 1
    }

    var preview: UIDocumentInteractionController? = nil
    @IBAction func openin(sender: UIBarButtonItem) {
        if let presentedItemURL = self.presentedItemURL {
            self.preview = UIDocumentInteractionController(URL: presentedItemURL)
            if let preview = self.preview {
                preview.delegate = self
                preview.presentOptionsMenuFromBarButtonItem(sender, animated: true)
            }
        }
    }
    
    func relinquishPresentedItemToReader(reader: ((() -> Void)!) -> Void) {
        if let url = self.presentedItemURL {
            url.stopAccessingSecurityScopedResource()
        }
    }
    
    func relinquishPresentedItemToWriter(writer: ((() -> Void)!) -> Void) {
        if let url = self.presentedItemURL {
            url.stopAccessingSecurityScopedResource()
        }
    }
    
    func presentedItemDidGainVersion(version: NSFileVersion) {
    }
    
    func presentedItemDidLoseVersion(version: NSFileVersion) {
    }
    
    func presentedItemDidResolveConflictVersion(version: NSFileVersion) {
    }
    
    func presentedSubitemAtURL(url: NSURL, didGainVersion version: NSFileVersion) {
    }
    
    func presentedSubitemAtURL(url: NSURL, didLoseVersion version: NSFileVersion) {
    }
    
    func presentedSubitemAtURL(url: NSURL, didResolveConflictVersion version: NSFileVersion) {
    }
    
    func accommodatePresentedItemDeletionWithCompletionHandler(completionHandler: (NSError!) -> Void) {
    }
    
    func presentedSubitemDidAppearAtURL(url: NSURL) {
    }
    
    func presentedSubitemAtURL(oldURL: NSURL, didMoveToURL newURL: NSURL) {
    }
    
    func presentedSubitemDidChangeAtURL(url: NSURL) {
    }

}

