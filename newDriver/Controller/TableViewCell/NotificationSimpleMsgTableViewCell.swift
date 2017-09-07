//
//  NotificationSimpleMsgTableViewCell.swift
//  newDriver
//
//  Created by 凯东源 on 16/12/2.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class NotificationSimpleMsgTableViewCell: UITableViewCell {
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    /// 消息类型
    @IBOutlet weak var typeTitleLabel: UILabel!
    
    /// 公告标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 推送时间
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 未读小红点
    @IBOutlet weak var badge: UIImageView!
    
    /// 订单ID
    var orderID: String! = ""
    
    /// 图标
    @IBOutlet weak var typeIcon: UIImageView!
    
}
