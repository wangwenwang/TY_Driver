//
//  OrderDetailsTableViewCell.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/28.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {
    
    
    /// 订单详情
    var orderDetail: OrderDetail? {
        didSet {
            updataUI()
        }
    }
    
    /// 产品名称
    @IBOutlet weak var productNameField: UILabel!
    
    /// 产品数量
    @IBOutlet weak var orderQTYField: UILabel!
    
    /// 产品重量
    @IBOutlet weak var orderWeightField: UILabel!
    
    /// 产品体积
    @IBOutlet weak var orderVolumeField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    fileprivate func updataUI () {
        productNameField.text = "\((orderDetail?.PRODUCT_NAME)!)(\((orderDetail?.PRODUCT_NO)!))"
        orderQTYField.text = "\((orderDetail?.ISSUE_QTY)!)\((orderDetail?.ORDER_UOM)!)"
        orderWeightField.text = "\((orderDetail?.ISSUE_WEIGHT)!)吨"
        orderVolumeField.text = "\((orderDetail?.ISSUE_VOLUME)!)方"
    
        productNameField.sizeToFit()
        let screenWidth : CGFloat = UIScreen.main.bounds.width
        //溢出宽度
        let overflowWidth : CGFloat = productNameField.frame.size.width - (screenWidth - 16 - 20)
        if(overflowWidth > 0) {
            UIView.beginAnimations("textAnimation", context: nil)
            UIView.setAnimationDuration(TimeInterval(overflowWidth) / 6.0)
            UIView.setAnimationCurve(UIViewAnimationCurve.linear)
            UIView.setAnimationDelegate(self)
            UIView.setAnimationRepeatAutoreverses(true)
            UIView.setAnimationRepeatCount(999999)
            productNameField.frame.origin.x = overflowWidth
            UIView.commitAnimations()
        }
    }
    
}
