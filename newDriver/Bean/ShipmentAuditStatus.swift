//
//  ShipmentAuditStatus.swift
//  newDriver
//
//  Created by 凯东源 on 17/3/23.
//  Copyright © 2017年 凯东源. All rights reserved.
//


import Foundation
import ObjectMapper


/// 装运计费情况
class ShipmentAuditStatus: BaseBean {
    
    /// 错误标识  值为Y 或 N，    ""认为是N
    var ERROR_FLAG: String = ""
    
    /// 计费标识  值为Y 或 N，    ""认为是N
    var AUDIT_FLAG: String = ""
    
    /// 错误消息
    var ERROR_DESC: String = ""
    
    override func mapping(map: Map) {
        ERROR_FLAG <- map["ERROR_FLAG"]
        AUDIT_FLAG <- map["AUDIT_FLAG"]
        ERROR_DESC <- map["ERROR_DESC"]
    }
}
