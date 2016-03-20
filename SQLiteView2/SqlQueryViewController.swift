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

        // 执行sql语句，如果有错误，也在recordset中输出错误信息，偷懒的做法:)
        do {
            let stmt = try document.db.prepare(sql!)
            mainVC.queryVC.recordset = stmt.output()
        } catch let error as NSError {
            mainVC.queryVC.recordset = errorToRecordset(error)
        } catch {
            NSLog("all error")
        }
    }
}
