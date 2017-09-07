//
//  LocationContineTime.swift
//  newDriver
//
//  Created by 凯东源 on 16/7/7.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import ObjectMapper


/// 位置点信息包含时间
class LocationContineTime {

    /// 递增序列，用于给后台插入数据库排序用
    var ID: String = ""
    
    /// 保存位置用户的 id
    var USERIDX: String = ""
    
    /// 位置纬度
    var CORDINATEX: Double = 0.0
    
    /// 位置经度
    var CORDINATEY: Double = 0.0
    
    /// 位置的地址
    var ADDRESS: String = ""
    
    /// 位置创建的时间
    var TIME: String = ""
    
    
}































