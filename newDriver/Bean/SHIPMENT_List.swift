//
//  SHIPMENT_List.swift
//  newDriver
//
//  Created by 凯东源 on 16/12/15.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import ObjectMapper

class SHIPMENT_List: BaseBean {
    
    /// 订单号
    var ORD_NO: String = ""
    
    /// 订单ID
    var ORD_IDX: String = ""
    
    /// 客户订单号
    var ORD_NO_CLIENT: String = ""
    
    override func mapping(map: Map) {
        ORD_NO <- map["ORD_NO"]
        ORD_IDX <- map["ORD_IDX"]
        ORD_NO_CLIENT <- map["ORD_NO_CLIENT"]
    }
}
