//
//  StateTr.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/27.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import ObjectMapper


/// 订单节点信息
class StateTack: BaseBean {

    /// 时间
    var STATE_TIME: String = ""
    /// 节点
    var ORDER_STATE: String = ""
    
    override func mapping(map: Map) {
        STATE_TIME <- map["STATE_TIME"]
        ORDER_STATE <- map["ORDER_STATE"]
    }
    
}



































