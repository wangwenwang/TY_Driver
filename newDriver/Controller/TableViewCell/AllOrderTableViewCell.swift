//
//  AllOrderTableViewCell.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/28.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class AllOrderTableViewCell: UITableViewCell {

    
    /// 订单信息
    var order: Order! {
        didSet {
            upDataUi()
        }
    }
    
    /// 订单编号
    @IBOutlet weak var orderNumberField: UILabel!
    
    /// 客户单号
    @IBOutlet weak var ORD_NO_CLIENT: UILabel!
    
    /// 计费状态
    @IBOutlet weak var auditStatus: UILabel!
    
    /// 装运编号
    @IBOutlet weak var orderShipmentNumberField: UILabel!
    
    /// 装运时间
    @IBOutlet weak var orderLoadDateField: UILabel!
    
    /// 出库时间
    @IBOutlet weak var orderIssueDateField: UILabel!
    
    /// 订单流程
    @IBOutlet weak var orderWorkFlowField: UILabel!
    
    /// 交付状态
    @IBOutlet weak var orderPayStateField: UILabel!
    
    /// 订单数量
    @IBOutlet weak var orderIssueQtyField: UILabel!
    
    /// 订单重量
    @IBOutlet weak var orderIssueWeightField: UILabel!
    
    /// 订单体积
    @IBOutlet weak var orderIssueVolumeField: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    fileprivate func upDataUi () {
        if order != nil {
            orderNumberField.text = order.ORD_NO
            ORD_NO_CLIENT.text = order.ORD_NO_CLIENT
            orderShipmentNumberField.text = order.TMS_SHIPMENT_NO
            orderLoadDateField.text = order.TMS_DATE_LOAD
            orderIssueDateField.text = order.TMS_DATE_ISSUE
            orderWorkFlowField.text = StringUtils.getOrderStatus(order.ORD_WORKFLOW)
            orderPayStateField.text = StringUtils.getOrderState(order.DRIVER_PAY)
            orderIssueQtyField.text = Tools.twoDecimal(text: order.ORD_ISSUE_QTY) + "件"
            orderIssueWeightField.text = Tools.twoDecimal(text: order.ORD_ISSUE_WEIGHT) + "吨"
            orderIssueVolumeField.text = Tools.twoDecimal(text: order.ORD_ISSUE_VOLUME) + "方"
        }
    }
}

























