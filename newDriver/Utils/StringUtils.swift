//
//  StringUtils.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/27.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation


class StringUtils {

    /**
    * 获取订单状态
    *
    * str: 后台返回的订单状态，英文字符
    *
    * return 订单状态，中文字符
    */
    static func getOrderStatus (_ str: String) -> String {
        if str.isEmpty {
            return ""
        }
        switch str {
        case "CLOSE":
            return "已完成"
        case "OPEN":
            return "在途"
        case "CANCEL":
            return "已取消"
        case "PENDING":
            return "待接收"
        default:
            return str
        }
    }
    
    /**
     * 获取订单流程
     *
     * str: 后台返回的订单流程状态，英文字符
     *
     * return 订单流程状态，中文字符
     */
    static func getOrderState (_ str: String) -> String {
        if str.isEmpty {
            return ""
        }
        switch str {
        case "新建":
            return "已接收"
        case "已释放":
            return "待装货"
        case "已确认":
            return "已拼车"
        case "已回单":
            return "已完结"
        default:
            return str
        }
    }
    
}



























