//
//  MainWindowController.swift
//  SQLiteView2
//
//  Created by xt on 16/3/19.
//  Copyright © 2016年 xt. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    // 只有在NSDocument.makeWindowControllers执行完成后，NSWindowController中的document才被赋值
    // windowTitleForDocumentDisplayName是在NSDocument.makeWindowControllers之后执行的
    // 所以在此将document赋值给相关的view
    override func windowTitleForDocumentDisplayName(displayName: String) -> String {
        if let vc = contentViewController {
            let mainVC = vc as! MainViewController
            let doc = document as! Document
            mainVC.schemaVC.document = doc
            mainVC.schemaVC.dbItems = doc.db.tablesAndViews()
            mainVC.sqlQueryVC.document = doc
        }
        
        return super.windowTitleForDocumentDisplayName(displayName)
    }
}
