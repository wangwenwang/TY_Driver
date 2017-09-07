//
//  Shipment_OrderList.swift
//  newDriver
//
//  Created by 凯东源 on 17/3/23.
//  Copyright © 2017年 凯东源. All rights reserved.
//


import Foundation
import ObjectMapper

/// 装运信息下 的订单列表
class Shipment_OrderList: BaseBean {
    
    /// 订单号
    var ORD_NO: String = ""
    
    /// 客户订单号
    var ORD_NO_CLIENT: String = ""
    
    /// 订单状态
    var ORD_STATE: String = ""
    
    /// 订单流程
    var ORD_WORKFLOW: String = ""
    
    /// 交付状态
    var UPDATE03: String = ""
    
    /// 起运名称
    var ORD_FROM_NAME: String = ""
    
    /// 到达名称
    var ORD_TO_NAME: String = ""
    
    /// 计费量
    var CHARGE_AMOUNT: String = ""
    
    /// 运输费
    var TRANSPORT_FEES: String = ""
    
    /// 分点费
    var DROPPOINT_FEES: String = ""
    
    /// 装卸费
    var LOAD_FEES: String = ""
    
    /// 收货人附加费
    var SITE_SURCHARGE: String = ""
    
    /// 燃油附加费
    var FUEL_SURCHARGE: String = ""
    
    /// 退货费
    var RETURN_FEES: String = ""
    
    /// 提送货费
    var DELIVER_FEES: String = ""
    
    /// 压夜费
    var PRESS_NIGHT: String = ""
    
    /// 其他费
    var OTHER_FEES: String = ""
    
    /// 计费单价
    var AMOUNT_PRICE: String = ""
    
    /// 总费用
    var FEESCOUNT: String = ""
    
    /// 总量
    var ORD_QTY: String = ""
    
    /// 重量
    var ORD_WEIGHT: String = ""
    
    /// 体积
    var ORD_VOLUME: String = ""
    
    override func mapping(map: Map) {
        ORD_NO <- map["ORD_NO"]
        ORD_NO_CLIENT <- map["ORD_NO_CLIENT"]
        ORD_STATE <- map["ORD_STATE"]
        ORD_WORKFLOW <- map["ORD_WORKFLOW"]
        UPDATE03 <- map["UPDATE03"]
        ORD_FROM_NAME <- map["ORD_FROM_NAME"]
        ORD_TO_NAME <- map["ORD_TO_NAME"]
        CHARGE_AMOUNT <- map["CHARGE_AMOUNT"]
        TRANSPORT_FEES <- map["TRANSPORT_FEES"]
        DROPPOINT_FEES <- map["DROPPOINT_FEES"]
        LOAD_FEES <- map["LOAD_FEES"]
        SITE_SURCHARGE <- map["SITE_SURCHARGE"]
        FUEL_SURCHARGE <- map["FUEL_SURCHARGE"]
        RETURN_FEES <- map["RETURN_FEES"]
        DELIVER_FEES <- map["DELIVER_FEES"]
        PRESS_NIGHT <- map["PRESS_NIGHT"]
        OTHER_FEES <- map["OTHER_FEES"]
        AMOUNT_PRICE <- map["AMOUNT_PRICE"]
        FEESCOUNT <- map["FEESCOUNT"]
        ORD_QTY <- map["ORD_QTY"]
        ORD_WEIGHT <- map["ORD_WEIGHT"]
        ORD_VOLUME <- map["ORD_VOLUME"]
    }
}
