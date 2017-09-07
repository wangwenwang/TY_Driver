//
//  OrderViewController.swift
//  kdyDriver
//
//  Created by 凯东源 on 16/6/24.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    
    /// 已交付、未交付、全部 订单滑动控件
    fileprivate var pageMenu: CAPSPageMenu?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "订单查询"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        
        var controllerArray: [UIViewController] = []
        
        let notPayOrderController: NotPayTableViewController = NotPayTableViewController(nibName: "NotPayTableViewController", bundle: nil)
        notPayOrderController.title = "未交付"
        controllerArray.append(notPayOrderController)
        
        let payedOrderController: PayedTableViewController = PayedTableViewController(nibName: "PayedTableViewController", bundle: nil)
        payedOrderController.title = "已交付"
        controllerArray.append(payedOrderController)
        
        let allOrderController: AllTableViewController = AllTableViewController(nibName: "AllTableViewController", bundle: nil)
        allOrderController.title = "全部"
        controllerArray.append(allOrderController)
        
        let parameters: [CAPSPageMenuOption] = [
            .selectedMenuItemLabelColor(AppDelegate.TYColor),
            .scrollMenuBackgroundColor(UIColor.init(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1)),
            .viewBackgroundColor(UIColor.init(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1)),
            .selectionIndicatorColor(AppDelegate.TYColor),
            .bottomMenuHairlineColor(UIColor.init(colorLiteralRed: 0.97, green: 0.97, blue: 0.97, alpha: 1)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .menuHeight(35.0),
            .menuItemWidth((self.view.frame.width - 60) / 3),
            .centerMenuItems(true)
        ]
        
        let height = (self.navigationController?.navigationBar.frame.height)! + AppDelegate.statusBarHeight
        let tarBarHeight = self.tabBarController?.tabBar.frame.height
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: height, width: self.view.frame.width, height: self.view.frame.height - height - tarBarHeight!), pageMenuOptions: parameters)

        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        pageMenu!.didMove(toParentViewController: self)
    }
}
