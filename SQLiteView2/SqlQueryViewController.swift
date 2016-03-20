//
//  SqlQueryViewController.swift
//  SQLiteView2
//
//  Created by xt on 16/3/19.
//  Copyright © 2016年 xt. All rights reserved.
//

import Cocoa

class SqlQueryViewController: NSViewController {

    @IBOutlet var sqlView: NSTextView!
    
    var document: Document!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func executeSql(sender: NSMenuItem) {
        let sql = sqlView.string
        let mainVC = parentViewController?.parentViewController?.parentViewController as! MainViewController
        
        let stmt = try! document.db.prepare(sql!)
        mainVC.queryVC.recordset = stmt.output()
    }
}
