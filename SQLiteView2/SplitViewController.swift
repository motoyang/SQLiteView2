//
//  SplitViewController.swift
//  SQLiteView2
//
//  Created by xt on 16/3/19.
//  Copyright © 2016年 xt. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 只能在viewDidLoad完成后，调整splitView的相对大小，在其他地方调整似乎没有效果
        splitView.adjustSubviews()
    }
    
}
