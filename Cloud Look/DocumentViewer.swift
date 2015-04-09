//
//  DocumentViewer.swift
//  Cloud Look
//
//  Created by Mike Barriault on 2015/04/09.
//  Copyright (c) 2015 Mike Barriault. All rights reserved.
//

import UIKit
import QuickLook

class DocumentViewer: QLPreviewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource, UIDocumentInteractionControllerDelegate, NSFilePresenter {
    
    weak var parentController: UIViewController!
    var presentedItemURL: NSURL? = nil
    var openinButton: UIBarButtonItem!
    var coordinator: NSFileCoordinator!
    var presentedItemOperationQueue = NSOperationQueue.mainQueue()
    
    override func viewDidLoad() {
        self.delegate = self
        self.dataSource = self
        
        openinButton = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "openin")
    }
    
    func previewController(controller: QLPreviewController!, previewItemAtIndex index: Int) -> QLPreviewItem! {
        return presentedItemURL
    }
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController!) -> Int {
        return 1
    }
    
    func load(presentedItemURL: NSURL, parentController: UIViewController) {
        self.presentedItemURL = presentedItemURL
        presentedItemURL.startAccessingSecurityScopedResource()
        coordinator = NSFileCoordinator(filePresenter: self)
        NSFileCoordinator.addFilePresenter(self)
        
        self.parentController = parentController
        parentController.title = presentedItemURL.lastPathComponent
        self.view.frame = parentController.view.frame
        parentController.view.addSubview(self.view)
        self.didMoveToParentViewController(parentController)
        parentController.navigationItem.rightBarButtonItem = self.openinButton!
    }
    
    func openin(sender: UIBarButtonItem) {
        let interact = UIDocumentInteractionController(URL: presentedItemURL!)
        interact.delegate = self
        interact.presentOptionsMenuFromBarButtonItem(sender, animated: true)
    }
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return parentController
    }
    
    func documentInteractionController(controller: UIDocumentInteractionController, willBeginSendingToApplication application: String) {
        presentedItemURL?.stopAccessingSecurityScopedResource()
    }
    
    func unload() {
        parentController.navigationItem.rightBarButtonItem = nil
        self.removeFromParentViewController()
        self.view.removeFromSuperview()
        parentController.title = ""
        NSFileCoordinator.removeFilePresenter(self)
        self.presentedItemURL?.stopAccessingSecurityScopedResource()
        self.presentedItemURL = nil
    }
    
    func relinquishPresentedItemToReader(reader: ((() -> Void)!) -> Void) {
        unload()
    }
    
    func relinquishPresentedItemToWriter(writer: ((() -> Void)!) -> Void) {
        unload()
    }

    func presentedItemDidGainVersion(version: NSFileVersion) {
        unload()
    }
    
    func presentedItemDidLoseVersion(version: NSFileVersion) {
        unload()
    }
    
    func presentedItemDidResolveConflictVersion(version: NSFileVersion) {
        unload()
    }
    
    func presentedSubitemAtURL(url: NSURL, didGainVersion version: NSFileVersion) {
        unload()
    }
    
    func presentedSubitemAtURL(url: NSURL, didLoseVersion version: NSFileVersion) {
        unload()
    }
    
    func presentedSubitemAtURL(url: NSURL, didResolveConflictVersion version: NSFileVersion) {
        unload()
    }
    
    func accommodatePresentedItemDeletionWithCompletionHandler(completionHandler: (NSError!) -> Void) {
        unload()
    }
    
    func presentedSubitemDidAppearAtURL(url: NSURL) {
        unload()
    }
    
    func presentedSubitemAtURL(oldURL: NSURL, didMoveToURL newURL: NSURL) {
        unload()
    }
    
    func presentedSubitemDidChangeAtURL(url: NSURL) {
        unload()
    }
}
