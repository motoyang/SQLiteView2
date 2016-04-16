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
        
        adjustTitlebar("ExtrabarViewController")
    }
    
    @IBAction func sideView(sender: NSMenuItem) {
        if let vc = contentViewController {
            let mainVC = vc as! MainViewController
            mainVC.sideView(sender)
        }
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
        
        // 调整titleIcon的位置，这个icon是在打开document后，才加入titlebar中的，注意subview的index，这个index是会改变的。
        let containerView = window?.contentView?.superview?.subviews[1]
        let titlebarView = (containerView?.subviews[0])!
        let titleText = titlebarView.subviews[3]
        let titleIcon = titlebarView.subviews[7]
        titleIcon.translatesAutoresizingMaskIntoConstraints = false
        titlebarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[titleIcon(==w)]-[titleText]", options: .AlignAllCenterY, metrics: ["w": titleIcon.frame.width, "h": titleIcon.frame.height], views: ["titleText": titleText, "titleIcon": titleIcon]))
        
        return super.windowTitleForDocumentDisplayName(displayName)
    }
    
    func adjustTitlebar(nibName: String) {
        /** Window中的view关系
         window+->NSThemeView+->NSContentView（最常用的view，平常的view都是增加在这个view中）
                             +->NSContainerView+->NSTitlebarView+->NSButton(close)
                                                                +->NSButton(max)
                                                                +->NSButton(min)
                                                                +->NSTextField(title)
                                                                +->NSView（addTitlebarAccessoryViewController加入的view，用于增加titlebar的高度）
                                                                +->NSView（通过addSubview加入的view，可以是NSControl等）
         */
         
         // 按照上述的view结构，获取titlebarView
        let containerView = window?.contentView?.superview?.subviews[1]
        let titlebarView = containerView?.subviews[0]
        print(titlebarView?.constraints.count)
        titlebarView?.removeConstraints((titlebarView?.constraints)!)
        
        // 通过xib文件中的view，增加titlebar的高度，增加的高度就是view.frame.height，实际上这个view可以不显示
        let extraViewController = NSTitlebarAccessoryViewController(nibName: nibName, bundle: nil)!
        extraViewController.layoutAttribute = .Bottom
        window?.addTitlebarAccessoryViewController(extraViewController)
        extraViewController.view.hidden = true
        
        // 将titlebar中的三个按钮和title调整到垂直中间位置
        centerElement(titlebarView!)
        
        // 在titlebarView中，增加自定义的control
        addControl(titlebarView!)
    }
    
    func centerElement(titlebarView: NSView) {
        // 先设置左边三个按钮的约束条件
        for var i = 0; i < 3; ++i {
            let e = titlebarView.subviews[i]
            e.translatesAutoresizingMaskIntoConstraints = false
            titlebarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-ledding-[e]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["ledding": e.frame.origin.x, "w": e.frame.width], views: ["e": e]))
            titlebarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[e]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["h": e.frame.height], views: ["e": e]))
            titlebarView.addConstraint(NSLayoutConstraint(item: e, attribute: .CenterY, relatedBy: .Equal, toItem: titlebarView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        }
        
        // 设置title的约束条件，注意约束的优先级
        print(titlebarView.subviews.count)
        let maxButton = titlebarView.subviews[1]
        let titleText = titlebarView.subviews[3]
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titlebarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[maxButton]->=12-[titleText]", options: .AlignAllCenterY, metrics: nil, views: ["maxButton": maxButton, "titleText": titleText]))
        let c = NSLayoutConstraint(item: titleText, attribute: .CenterX, relatedBy: .Equal, toItem: titlebarView, attribute: .CenterX, multiplier: 1.0, constant: 0)
        c.priority = 250
        titlebarView.addConstraint(c)
    }
    
    func addControl(titlbarView: NSView) {
        // 增加一个playView到titlebar中，位置在titleText的右边
        let playViewController = NSViewController(nibName: "PlayViewController", bundle: nil)!
        let playView = playViewController.view
        playView.translatesAutoresizingMaskIntoConstraints = false
        titlbarView.addSubview(playView)
        
        let titleText = titlbarView.subviews[3]
        titlbarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[titleText]-15-[playView(==w)]", options: .AlignAllCenterY, metrics: ["w": playView.frame.width], views: ["titleText": titleText, "playView": playView]))
        titlbarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[playView(==h)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["h": playView.frame.height], views: ["titleText": titleText, "playView": playView]))

        // 增加一个sideView到titlebar中，位置在bitlebar的最左边
        let sideViewController = NSViewController(nibName: "SideViewController", bundle: nil)!
        let sideView = sideViewController.view
        sideView.translatesAutoresizingMaskIntoConstraints = false
        titlbarView.addSubview(sideView)
        
        titlbarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[playView]->=15-[sideView(==w)]-|", options: .AlignAllCenterY, metrics: ["w": sideView.frame.width], views: ["playView": playView, "sideView": sideView]))
        titlbarView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sideView(==h)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["h": sideView.frame.height], views: ["playView": playView, "sideView": sideView]))
    }

}
