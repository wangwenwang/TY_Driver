//
//  OrderAutographAndPicture.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import ObjectMapper


/// 订单签名或图片信息
class OrderAutographAndPicture: BaseBean {

    /// 图片类型为客户签名
    let AUTOGRAPH: String = "Autograph"
    ///图片类型为现场图片
    let PICTURE: String = "pricture"
    
    ///
    var IDX: String = ""
    ///
    var PRODUCT_IDX: String = ""
    /// 图片路径
    var PRODUCT_URL: String = ""
    /// 标记图片时签名还是现场图片 "Autograph"为签名  "pricture"为现场图片
    var REMARK: String = ""
    
    override func mapping(map: Map) {
        IDX <- map["IDX"]
        PRODUCT_IDX <- map["PRODUCT_IDX"]
        PRODUCT_URL <- map["PRODUCT_URL"]
        REMARK <- map["REMARK"]
    }

}



































