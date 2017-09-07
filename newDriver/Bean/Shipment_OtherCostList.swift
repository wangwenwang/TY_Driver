//
//  Shipment_OtherCostList.swift
//  newDriver
//
//  Created by 凯东源 on 17/3/23.
//  Copyright © 2017年 凯东源. All rights reserved.
//

import Foundation
import ObjectMapper

class Shipment_OtherCostList: BaseBean {
    
    
    /// 订单号
    var ORD_NO: String = ""
    
    /// 费用类型
    var FEE_TYPE: String = ""
    
    /// 其他费
    var OTHER_FEES: String = ""
    
    /// 费用说明
    var FEE_DESC: String = ""
    
    override func mapping(map: Map) {
        ORD_NO <- map["ORD_NO"]
        FEE_TYPE <- map["FEE_TYPE"]
        OTHER_FEES <- map["OTHER_FEES"]
        FEE_DESC <- map["FEE_DESC"]
    }
}
