//
//  OrderBillingTableViewCell.swift
//  newDriver
//
//  Created by 凯东源 on 17/3/22.
//  Copyright © 2017年 凯东源. All rights reserved.
//

import UIKit

class OrderBillingTableViewCell: UITableViewCell {
    
    /// 订单号
    @IBOutlet weak var ORD_NO: UILabel!
    
    /// 客户订单号
    @IBOutlet weak var ORD_NO_CLIENT: UILabel!
    
    /// 起运名称
    @IBOutlet weak var ORD_FROM_NAMES: UILabel!
    
    /// 到达名称
    @IBOutlet weak var ORD_TO_NAME: UILabel!
    
    /// 计费量
    @IBOutlet weak var CHARGE_AMOUNT: UILabel!
    
    /// 运输费
    @IBOutlet weak var TRANSPORT_FEES: UILabel!
    
    /// 分点费
    @IBOutlet weak var DROPPOINT_FEES: UILabel!
    
    /// 退货费
    @IBOutlet weak var RETURN_FEES: UILabel!
    
    /// 压夜费
    @IBOutlet weak var PRESS_NIGHT: UILabel!
    
    /// 装卸费
    @IBOutlet weak var LOAD_FEES: UILabel!
    
    /// 其他费
    @IBOutlet weak var OTHER_FEES: UILabel!
    
    /// 总量
    @IBOutlet weak var ORD_QTY: UILabel!
    
    /// 重量
    @IBOutlet weak var ORD_WEIGHT: UILabel!
    
    /// 体积
    @IBOutlet weak var ORD_VOLUME: UILabel!
    
    /// 提送货费
    @IBOutlet weak var DELIVER_FEES: UILabel!
    
    /// 计费单价
    @IBOutlet weak var AMOUNT_PRICE: UILabel!
    
    /// 燃油附加费
    @IBOutlet weak var FUEL_SURCHARGE: UILabel!
    
    /// 收货人附加费
    @IBOutlet weak var SITE_SURCHARGE: UILabel!
    
    /// 总费用
    @IBOutlet weak var FEESCOUNT: UILabel!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    
    @IBOutlet weak var top: NSLayoutConstraint!
    
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    @IBOutlet weak var bottom: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewx: UIView!
    
    var orderListM: Shipment_OrderList! {
        didSet {
            
            updateUI()
            
            // 去掉框框
            leading.constant = 0
            top.constant = 0
            trailing.constant = 0
            bottom.constant = 1
            contentViewx.layer.cornerRadius = 0
        }
    }
    
    var isThisOrder: Int! {
        didSet {
            
            
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func updateUI() {
        
        if orderListM != nil {
            
            ORD_NO.text = orderListM.ORD_NO
            ORD_NO_CLIENT.text = orderListM.ORD_NO_CLIENT
            ORD_FROM_NAMES.text = orderListM.ORD_FROM_NAME
            ORD_TO_NAME.text = orderListM.ORD_TO_NAME
            CHARGE_AMOUNT.text = Tools.twoDecimal(text: orderListM.CHARGE_AMOUNT)
            TRANSPORT_FEES.text = Tools.twoDecimal(text: orderListM.TRANSPORT_FEES)
            DROPPOINT_FEES.text = Tools.twoDecimal(text: orderListM.DROPPOINT_FEES)
            RETURN_FEES.text = Tools.twoDecimal(text: orderListM.RETURN_FEES)
            PRESS_NIGHT.text = Tools.twoDecimal(text: orderListM.PRESS_NIGHT)
            LOAD_FEES.text = Tools.twoDecimal(text: orderListM.LOAD_FEES)
            OTHER_FEES.text = Tools.twoDecimal(text: orderListM.OTHER_FEES)
            ORD_QTY.text = Tools.twoDecimal(text: orderListM.ORD_QTY) + "件"
            ORD_WEIGHT.text = Tools.twoDecimal(text: orderListM.ORD_WEIGHT) + "吨"
            ORD_VOLUME.text = Tools.twoDecimal(text: orderListM.ORD_VOLUME) + "方"
            DELIVER_FEES.text = Tools.twoDecimal(text: orderListM.DELIVER_FEES)
            AMOUNT_PRICE.text = orderListM.AMOUNT_PRICE
            FUEL_SURCHARGE.text = Tools.twoDecimal(text: orderListM.FUEL_SURCHARGE)
            SITE_SURCHARGE.text = Tools.twoDecimal(text: orderListM.SITE_SURCHARGE)
            FEESCOUNT.text = Tools.twoDecimal(text: orderListM.FEESCOUNT)
        }
    }
}
