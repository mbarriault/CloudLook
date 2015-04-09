//
//  DocumentPicker.swift
//  Cloud Look
//
//  Created by Mike Barriault on 2015/04/09.
//  Copyright (c) 2015 Mike Barriault. All rights reserved.
//

import UIKit
import MobileCoreServices

class DocumentPicker: UIDocumentPickerViewController, UIDocumentPickerDelegate {
    var viewer: DocumentViewer? = nil
    var parentController: UIViewController!
    
    let UTIs = [kUTTypeText, kUTTypePlainText, kUTTypeUTF8PlainText, kUTTypeUTF16ExternalPlainText, kUTTypeUTF16PlainText, kUTTypeRTF, kUTTypeHTML, kUTTypeXML, kUTTypeSourceCode, kUTTypeCSource, kUTTypeObjectiveCSource, kUTTypeCPlusPlusSource, kUTTypeObjectiveCPlusPlusSource, kUTTypeCHeader, kUTTypeCPlusPlusHeader, kUTTypeJavaSource, kUTTypePDF, kUTTypeRTFD, kUTTypeFlatRTFD, kUTTypeTXNTextAndMultimediaData, kUTTypeWebArchive, kUTTypeImage, kUTTypeJPEG, kUTTypeJPEG2000, kUTTypeTIFF, kUTTypePICT, kUTTypeGIF, kUTTypePNG, kUTTypeQuickTimeImage, kUTTypeAppleICNS, kUTTypeBMP, kUTTypeICO, kUTTypeAudiovisualContent, kUTTypeMovie, kUTTypeVideo, kUTTypeAudio, kUTTypeQuickTimeMovie, kUTTypeMPEG, kUTTypeMPEG4, kUTTypeMP3, kUTTypeMPEG4Audio, kUTTypeAppleProtectedMPEG4Audio, kUTTypePackage]
    
    init() {
        super.init(documentTypes: self.UTIs, inMode: .Open)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func pick(parentController: UIViewController) {
        self.parentController = parentController
        parentController.presentViewController(self, animated: true) { () -> Void in
            
        }
    }
    
    override func viewDidLoad() {
        self.delegate = self
    }
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        if let viewer = viewer {
            viewer.unload()
            self.viewer = nil
        }
        viewer = DocumentViewer()
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            delegate.viewer = viewer!
        }
        viewer!.load(url, parentController: self.parentController!)
    }
    
    func documentPickerWasCancelled(controller: UIDocumentPickerViewController) {
    }
}
