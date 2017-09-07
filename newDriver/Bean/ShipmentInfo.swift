//
//  ShipmentInfo.swift
//  newDriver
//
//  Created by 凯东源 on 17/3/23.
//  Copyright © 2017年 凯东源. All rights reserved.
//

import Foundation
import ObjectMapper

class ShipmentInfo: BaseBean {
    
    /// 装运信息
    var ShipmentPart: ShipmentPart? = nil
    
    /// 订单信息
    var Shipment_OrderList: [Shipment_OrderList] = []
    
    /// 其他费用
    var Shipment_OtherCostList: [Shipment_OtherCostList] = []
    
    override func mapping(map: Map) {
        
        ShipmentPart <- map["Shipment"]
        Shipment_OrderList <- map["Order"]
        Shipment_OtherCostList <- map["Other"]
    }
}
