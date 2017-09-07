//
//  DateUtils.swift
//  newDriver
//
//  Created by 凯东源 on 16/7/7.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation


class DateUtils {

    /**
     * 获取手机当前时间
     *
     * return 手机当前时间 "yyy-MM-dd HH:mm:ss"
     */
    static func getCurrentDate () -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        return strNowTime
    }
    
}
