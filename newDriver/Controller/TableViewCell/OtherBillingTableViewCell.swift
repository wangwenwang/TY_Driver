//
//  OtherBillingTableViewCell.swift
//  newDriver
//
//  Created by 凯东源 on 17/3/22.
//  Copyright © 2017年 凯东源. All rights reserved.
//

import UIKit

class OtherBillingTableViewCell: UITableViewCell {
    
    
    /// 订单号
    @IBOutlet weak var ORD_NO: UILabel!
    
    /// 费用类型
    @IBOutlet weak var FEE_TYPE: UILabel!

    /// 其他费
    @IBOutlet weak var OTHER_FEES: UILabel!
    
    /// 费用说明
    @IBOutlet weak var FEE_DESC: UILabel!
    
    
    var otherBilling: Shipment_OtherCostList! {
        didSet {
            
            updateUI()
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
        
        if otherBilling != nil {
            
            ORD_NO.text = otherBilling.ORD_NO
            FEE_TYPE.text = otherBilling.FEE_TYPE
            OTHER_FEES.text = otherBilling.OTHER_FEES
            FEE_DESC.text = otherBilling.FEE_DESC
//            FEE_DESC.layer.cornerRadius
        }
    }
}
