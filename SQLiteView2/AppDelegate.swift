//
//  AppDelegate.swift
//  SQLiteView2
//
//  Created by xt on 16/3/16.
//  Copyright © 2016年 xt. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        if NSDocumentController.sharedDocumentController().documents.isEmpty {
//            let url = NSURL(fileURLWithPath: "/Users/xt/test/sqlite/Sakila.sqlite3")
//            NSDocumentController.sharedDocumentController().openDocumentWithContentsOfURL(url, display: true) {_,_,_ in return }

            NSDocumentController.sharedDocumentController().openDocument(self)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldOpenUntitledFile(sender: NSApplication) -> Bool {
        return false
    }
}

