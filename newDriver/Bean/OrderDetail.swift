//
//  OrderDetails.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/27.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import ObjectMapper


class OrderDetail: BaseBean {
    
    var PRODUCT_NO: String = ""
    var PRODUCT_NAME: String = ""
    var ORDER_QTY: Double = 0.0
    var ORDER_UOM: String = ""
    var ORDER_WEIGHT: String = ""
    
    var ORDER_VOLUME: String = ""
    var ISSUE_QTY: String = ""
    var ISSUE_WEIGHT: String = ""
    var ISSUE_VOLUME: String = ""
    var PRODUCT_PRICE: String = ""
    
    var ACT_PRICE: String = ""
    var MJ_PRICE: String = ""
    var MJ_REMARK: String = ""
    var ORG_PRICE: Double = 0.0
    var PRODUCT_URL: String = ""
    
    var PRODUCT_TYPE: String = ""
    
    override func mapping(map: Map) {
        PRODUCT_NO <- map["PRODUCT_NO"]
        PRODUCT_NAME <- map["PRODUCT_NAME"]
        ORDER_QTY <- map["ORDER_QTY"]
        ORDER_UOM <- map["ORDER_UOM"]
        ORDER_WEIGHT <- map["ORDER_WEIGHT"]
        
        ORDER_VOLUME <- map["ORDER_VOLUME"]
        ISSUE_QTY <- map["ISSUE_QTY"]
        ISSUE_WEIGHT <- map["ISSUE_WEIGHT"]
        ISSUE_VOLUME <- map["ISSUE_VOLUME"]
        PRODUCT_PRICE <- map["PRODUCT_PRICE"]
        
        ACT_PRICE <- map["ACT_PRICE"]
        MJ_PRICE <- map["MJ_PRICE"]
        MJ_REMARK <- map["MJ_REMARK"]
        ORG_PRICE <- map["ORG_PRICE"]
        PRODUCT_URL <- map["PRODUCT_URL"]
        
        PRODUCT_TYPE <- map["PRODUCT_TYPE"]
    }
    
}


























