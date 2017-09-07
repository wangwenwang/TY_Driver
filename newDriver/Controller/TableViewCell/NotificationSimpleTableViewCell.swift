//
//  NotificationSimpleTableViewCell.swift
//  newDriver
//
//  Created by 凯东源 on 16/11/22.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class NotificationSimpleTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// 推送标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 推送时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 订单ID
    var orderID: String! = ""
    
    /// 未读小红点
    @IBOutlet weak var badge: UIImageView!
    
}
