//
//  NewsViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/11/15.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
}

class NewsViewController: UIViewController {
    
    
    /// 推送公告标题
    var title1 : String!
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 推送公告内容
    var message : String!
    @IBOutlet weak var contentLabel: UILabel!

    /// 内容视图高度
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        titleLabel.font = UIFont.init(name: "Helvetica-Bold", size: 17.0)
        titleLabel.text = title1
        contentLabel.text = message
        
        
        let titleHeight : CGFloat! = title1.heightWithConstrainedWidth(width: SCREEN_WIDTH - 25, font: UIFont.init(name: "Helvetica-Bold", size: 17.0)!)
        let messageHeight : CGFloat! = message.heightWithConstrainedWidth(width: SCREEN_WIDTH - 25, font: contentLabel.font)
        //高度 = 标题与上高度(8) + 标题高度 + 内容与上高度(30) + 内容高度 + 内容与下高度(30)
        contentViewHeight.constant = titleHeight + messageHeight + 8 + 30 + 30
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
