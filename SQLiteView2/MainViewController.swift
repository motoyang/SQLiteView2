//
//  MainViewController.swift
//  SQLiteView2
//
//  Created by xt on 16/3/19.
//  Copyright © 2016年 xt. All rights reserved.
//

import Cocoa

class MainViewController: NSSplitViewController {

    var sideViewItem: NSSplitViewItem!
    
    var schemaVC: SchemaViewController!
    var sqlDefineVC: SqlDefineViewController!
    var recordsetVC: RecordsetViewController!
    var queryVC: RecordsetViewController!
    var sqlQueryVC: SqlQueryViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 调整splitView子窗口的大小
        splitView.adjustSubviews()
        sideViewItem = splitViewItems[0]
        
        //
        // 如下几行代码，设置几个关键subview的controller
        //
        schemaVC = splitViewItems[0].viewController as! SchemaViewController
        let tabVC = splitViewItems[1].viewController as! NSTabViewController
        
        var splitVC = tabVC.tabViewItems[0].viewController as! NSSplitViewController
        recordsetVC = splitVC.splitViewItems[0].viewController as! RecordsetViewController
        sqlDefineVC = splitVC.splitViewItems[1].viewController as! SqlDefineViewController
        
        splitVC = tabVC.tabViewItems[1].viewController as! NSSplitViewController
        sqlQueryVC = splitVC.splitViewItems[0].viewController as! SqlQueryViewController
        queryVC = splitVC.splitViewItems[1].viewController as! RecordsetViewController
    }
    
     func sideView(sender: NSMenuItem) {
        if splitViewItems.count == 2 {
            removeSplitViewItem(sideViewItem)
        } else {
            insertSplitViewItem(sideViewItem, atIndex: 0)
        }
    }
}
