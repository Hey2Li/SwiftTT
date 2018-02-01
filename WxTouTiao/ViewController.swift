//
//  ViewController.swift
//  WxTouTiao
//
//  Created by Tebuy on 2018/1/26.
//  Copyright © 2018年 Tebuy. All rights reserved.
//

import UIKit
import Moya
import PageMenu

class ViewController: UIViewController, CAPSPageMenuDelegate {
    var pageMenu:CAPSPageMenu!
    var controllers : [UIViewController] = []

    func showMenu() {
        Category.request { (cates) in
            self.controllers = cates!.map{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SB_NEWS") as! NewsTableViewController
                vc.title = $0.title
                vc.parentNavi = self.navigationController
                vc.id = $0.id
                return vc
            }
            
            let parameters: [CAPSPageMenuOption] = [
                .menuItemSeparatorWidth(4.3),
                .scrollMenuBackgroundColor(UIColor.white),
                .viewBackgroundColor(UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)),
                .bottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
                .selectionIndicatorColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
                .menuMargin(20.0),
                .menuHeight(40.0),
                .selectedMenuItemLabelColor(UIColor(red: 18.0/255.0, green: 150.0/255.0, blue: 225.0/255.0, alpha: 1.0)),
                .unselectedMenuItemLabelColor(UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)),
                .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
                .useMenuLikeSegmentedControl(true),
                .menuItemSeparatorRoundEdges(true),
                .selectionIndicatorHeight(2.0),
                .menuItemSeparatorPercentageHeight(0.1)
            ]
            let frame = CGRect(x: 0, y: 20 + 44, width: self.view.bounds.width, height: self.view.bounds.height - 20 - 44)
            self.pageMenu = CAPSPageMenu(viewControllers: self.controllers, frame: frame, pageMenuOptions: parameters)
            self.view.addSubview(self.pageMenu!.view)
            self.pageMenu.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        showMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

