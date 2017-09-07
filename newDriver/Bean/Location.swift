//
//  Location.swift
//  newDriver
//
//  Created by 凯东源 on 16/7/5.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import ObjectMapper


/// 位置点信息
class Location: BaseBean {

    ///
    var IDX: String = ""
    /// 坐标的维度
    var CORDINATEX: Double = 0.0
    /// 坐标经度
    var CORDINATEY: Double = 0.0
    /// 坐标地址
    var ADDRESS: String = ""
    /// 坐标生成时间
    var INSERT_DATE: String = ""
    
    override func mapping(map: Map) {
        IDX <- map["IDX"]
        ADDRESS <- map["ADDRESS"]
        INSERT_DATE <- map["INSERT_DATE"]
    }
}
