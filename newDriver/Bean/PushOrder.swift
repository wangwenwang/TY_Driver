//
//  PushOrder.swift
//  newDriver
//
//  Created by 凯东源 on 16/12/13.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import ObjectMapper

/// 已推送的消息
class PushOrder: BaseBean {
    
    /// 内容
    var MESSAGE: String = ""
    
    /// 是否已读，0为未读  1为已读
    var ISREAD: String = ""
    
    /// 装运编号
    var SHIPMENTNO: String = ""
    
    /// 标题
    var TITLE: String = ""
    
    /// 推送订单号和订单ID
    var SHIPMENT_List: [SHIPMENT_List] = []
    
    /// 数据库序列号
    var IDX: String = ""
    
    /// 推送类型，0为订单  1为公告
    var TYPE: String = ""
    
    /// 推送时间
    var ADD_DATE: String = ""
    
    /// 装运ID
    var SHIPMENTIDX: String = ""
    
    /// 用户ID
    var USER_ID: String = ""
    
    override func mapping(map: Map) {
        MESSAGE <- map["MESSAGE"]
        ISREAD <- map["ISREAD"]
        SHIPMENTNO <- map["SHIPMENTNO"]
        TITLE <- map["TITLE"]
        SHIPMENT_List <- map["SHIPMENT_List"]
        IDX <- map["IDX"]
        TYPE <- map["TYPE"]
        ADD_DATE <- map["ADD_DATE"]
        SHIPMENTIDX <- map["SHIPMENTIDX"]
        USER_ID <- map["USER_ID"]
    }
}
