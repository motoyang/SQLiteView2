//
//  SchemaViewController.swift
//  SQLiteView2
//
//  Created by xt on 16/3/19.
//  Copyright © 2016年 xt. All rights reserved.
//

import Cocoa

class SchemaViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate  {
    
    @IBOutlet weak var outlineView: NSOutlineView!

    // SchemaView的dataModul，在AppDelegate中被赋值
    var document: Document!
    var dbItems: [DbItem]! {
        didSet {
            // 只有在dbItems被赋值后，才能设置outlineView的DataSource河Delegate，
            // 否则，系统在显示outlineView时，自动调用DataSource和Delegate的方法会产生异常
            outlineView.setDataSource(self)
            outlineView.setDelegate(self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
 
    // NSOutlineViewDataSource
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil {
            return dbItems[index]
        }
        
        let result = (item as! DbItem).children[index]
        return result
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return (item as! DbItem).children.count != 0
    }
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil {
            return dbItems.count
        }
        return (item as! DbItem).children.count
    }
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        return item
    }
    
    // NSOutlineViewDelegate
    func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
        return (item as! DbItem).catalog == .group
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        let s = item as! DbItem
        if s.catalog == .group {
            let cv = outlineView.makeViewWithIdentifier("GroupIdentifier", owner: self) as! NSTableCellView
            cv.textField?.stringValue = s.name
            return cv
        }

        let cv = outlineView.makeViewWithIdentifier("DbItemViewIdentifier", owner: self) as! NSTableCellView
        cv.textField?.stringValue = s.name
        
        var imgName = "DatabaseTable"
        if s.catalog == .primarykey {
            imgName = "PrimaryKey"
        } else if s.catalog == .column {
            imgName = "DatabaseColumn"
        }
        cv.imageView?.image = NSImage(named: imgName)
        
        return cv
    }
    
    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        let s = item as! DbItem
        if s.catalog == .table || s.catalog == .view {
            return true
        }
        
        return false
    }

    func outlineViewSelectionDidChange(notification: NSNotification) {
        
        // 通过选中的row得到DbItem
        let r = outlineView.selectedRow
        let item = outlineView.itemAtRow(r) as! DbItem
        
        // 设置DbItem的SqlDefine信息到SqlDefinView中
        let splitVC = parentViewController as! MainViewController
        var text: String = ""
        for s in item.sql {
            text += s.sql + "\r\n\r\n"
        }
        splitVC.sqlDefineVC.sqlTextView.string = text
        
        // 读取表中的数据
        let sql = "select * from \(item.name)"
        let stmt = try! document.db.prepare(sql)
        let mainVC = parentViewController as! MainViewController
        mainVC.recordsetVC.recordset = stmt.output()
    }
}
