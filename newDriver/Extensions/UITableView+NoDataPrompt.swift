//
//  UITableView+NoDataPrompt.swift
//  newDriver
//
//  Created by 凯东源 on 16/12/19.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import UIKit


extension UITableView {
    func noOrder(title : String) {
        //如果有，不实例
        let array : Array = self.subviews
        for view : UIView in array {
            if(view.tag == 10086) {
                view.isHidden = false
                return
            }
        }
        
        //外框
        let noOrderView : UIView = UIView.init()
        noOrderView.tag = 10086
        noOrderView.frame = CGRect.init(x: 0, y: 0, width: 120, height: 120)
        noOrderView.center = CGPoint.init(x: self.frame.size.width / 2, y: self.frame.size.height / 2 - 30)
        
        //图片
        let imageView : UIImageView = UIImageView.init(image: UIImage.init(named: "noOrder"))
        imageView.center = CGPoint.init(x: noOrderView.frame.size.width / 2, y: noOrderView.frame.size.height / 2)
        noOrderView.addSubview(imageView)
        
        //文字
        let label : UILabel = UILabel.init()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.init(name: label.font.fontName, size: 14)
        label.textColor = UIColor.init(red: 191 / 255.0, green: 191 / 255.0, blue: 191 / 255.0, alpha: 1.0)
        label.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 40)
        label.text = title
        label.center = CGPoint.init(x: noOrderView.frame.size.width / 2, y: noOrderView.frame.size.height / 2 + 60)
        noOrderView.addSubview(label)
        self.addSubview(noOrderView)
    }
    
    /// 隐藏提示
    func removeNoOrderPrompt() {
        let array : Array = self.subviews
        for view : UIView in array {
            if(view.tag == 10086) {
                view.isHidden = true
                break
            }
        }
    }
}
