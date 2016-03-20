//
//  RecordsetViewController.swift
//  SQLiteView2
//
//  Created by xt on 16/3/19.
//  Copyright © 2016年 xt. All rights reserved.
//

import Cocoa

class RecordsetViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    
    var recordset = [[String]]() {
        willSet {
            // 在每次重新设置recordset之前，要将datasource设置为nil，
            // 否则，在recordset有了新值后，datasource的numberOfRowsInTableView仍然是用的是旧值，
            // 会访问recordset超出范围的值
            tableView.setDataSource(nil)
        }
        
        didSet {
            // 先删除所有的tableColumn
            for col in tableView.tableColumns {
                tableView.removeTableColumn(col)
            }

            // 根据recordset中的首行信息，重现设置所有的tableColumn，
            // column的identifier被设置为column序号，后续根据这个序号，访问recordset中相应的列
            let t2 = recordset.removeFirst()
            for var i = 0; i < t2.count; ++i {
                let col = NSTableColumn(identifier: "\(i)")
                col.title = t2[i]
                tableView.addTableColumn(col)
            }

            // recordset被赋值后，重新设置datasource，系统会重现调研numberOfRowsInTableView，保证recordset的访问不越界
            tableView.setDataSource(self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.setDataSource(self)
        tableView.setDelegate(self)
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return recordset.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeViewWithIdentifier("CellWithLeftAlign", owner: self) as! NSTableCellView
        let col = Int((tableColumn?.identifier)!)!
        cellView.textField?.stringValue = recordset[row][col]
        return cellView
    }
}
