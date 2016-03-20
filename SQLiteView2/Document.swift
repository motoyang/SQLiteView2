//
//  Document.swift
//  SQLiteView2
//
//  Created by xt on 16/3/16.
//  Copyright © 2016年 xt. All rights reserved.
//

import Cocoa
import SQLite

class Document: NSDocument {

    var db: Connection!
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    // 重载这个属性，避免在退出时出现保存文件对话框
    override var documentEdited: Bool {
        return false
    }
    
    // 读取sqlite3数据库，并赋值到db中
    override func readFromURL(url: NSURL, ofType type: String) throws {
        let startIndex = url.absoluteString.startIndex.advancedBy(7)
        let path = url.absoluteString.substringFromIndex(startIndex)
        NSLog(path)
        db = try! Connection(path)
    }
    
    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class func autosavesInPlace() -> Bool {
        // 返回false，避免在sqlQuery view中的的输入导致document被设置为edited状态
        return false
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
        // 上边一行代码执行完成后，所以window、view相关的信息都建立了。
        
        // 这行代码，将windowcontroller和document关联起来，本行代码执行完成后，
        // 可以从windowcontroller.document中得到本document，
        // 也可以从document.windowControllers[0]中取得windowcontroller。
        self.addWindowController(windowController)
    }

    override func dataOfType(typeName: String) throws -> NSData {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }


}

