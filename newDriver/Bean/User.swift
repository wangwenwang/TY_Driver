//
//  User.swift
//  kdyDriver
//
//  Created by 凯东源 on 16/6/24.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import ObjectMapper

/// 登陆用户信息
class User: BaseBean {

    /// 用户名
    var USER_NAME: String = ""
    
    /// 用户类型，后台返回
    var USER_TYPE: String = ""
    
    /// 用户
    var USER_CODE: String = ""
    
    /// 用户唯一标识符，后台返回
    var IDX: String = ""
    
    /// 所在城市
    var CITY: String = ""
    
    override func mapping(map: Map) {
        USER_NAME <- map["USER_NAME"]
        USER_TYPE <- map["USER_TYPE"]
        USER_CODE <- map["USER_CODE"]
        IDX <- map["IDX"]
    }
    
    
}






