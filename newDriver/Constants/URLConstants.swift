//
//  URLConstants.swift
//  kdyDriver
//
//  Created by 凯东源 on 16/6/24.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation

struct URLConstants {
    
    /// 服务器地址
    static let baseUrl: String = "http://119.29.148.189:8888/api/"
    
    /// app 唯一标识符
    static let appId: String = "1279614793"
    
    /// 文件下载端口和文件夹
    static let loadUrl: String = "http://119.29.148.189:8888/"
    
    /// 服务端存放电子签名和现场图片的文件夹
    static let serverAutographAndPictureFile: String = "Uploadfile"
    
    /// 登陆接口
    static let loginUrl: String = URLConstants.baseUrl + "Login"
    
    /// 获取未交付订单列表接口 带时间
    static let API_GetDriverDateOrderClientList: String = URLConstants.baseUrl + "GetDriverDateOrderClientList"
    
    /// 修改登录密码
    static let changePassword: String = URLConstants.baseUrl + "modifyPassword"
    
    /// 获取物流信息详情   GetOrderTmsOrderNoInfo GetOrderTmsInfo
    static let getOrderTmsInfo = URLConstants.baseUrl + "GetOrderTmsOrderNoInfo"
    
    /// 获取最新版本 app 信息
    static let getAppVersionInfo = "https://itunes.apple.com/cn/lookup?id=" + URLConstants.appId
    
    /// 获取签名和现场图片
    static let getAutographAndPicture = URLConstants.baseUrl + "GetAutograph"
    
    /// 获取订单路线点位集合
    static let getOrderLoacations = URLConstants.baseUrl + "GetLocaltion"
    
    
    #if DEBUG
    
    /// 单点上传位置信息
    static let updataLocation = URLConstants.baseUrl + "CurrentLocaltion1"
    
    /// 上传位置点集合信息
    static let updataLocations = URLConstants.baseUrl + "CurrentLocaltionList1"
    
    /// 上传token
    static let uploadToken = URLConstants.baseUrl + "SavaPushToken1"
    #else
    
    /// 单点上传位置信息
    static let updataLocation = URLConstants.baseUrl + "CurrentLocaltion"
    
    /// 上传位置点集合信息
    static let updataLocations = URLConstants.baseUrl + "CurrentLocaltionList"
    
    /// 上传token
    static let uploadToken = URLConstants.baseUrl + "SavaPushToken"
    #endif
    
    /// 获取推送订单或公告
    static let getPushMessage = URLConstants.baseUrl + "GetMessage"
    
    /// 设置推送消息状态（已读或未读，未读是0，已读是1）
    static let setPushMessageStatus = URLConstants.baseUrl + "GetMessageDetils"
    
    /// 获取物流信息详情
    static let kAPI_GetPrice = URLConstants.baseUrl + "GetPrice"
    
    /// 获取装运编号下属指定状态订单列表
    static let kAPI_GetShipmentUnPayOrderList = URLConstants.baseUrl + "GetShipmentUnPayOrderList"
    
    /// 订单批量交付
    static let kAPI_DriverListPay = URLConstants.baseUrl + "DriverListPay"
    
}
