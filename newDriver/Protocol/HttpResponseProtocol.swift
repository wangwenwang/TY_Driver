//
//  HttpResponseProtocol.swift
//  kdyDriver
//
//  Created by 凯东源 on 16/6/24.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation

/// 网络请求协议
@objc protocol HttpResponseProtocol {
    
    /// 网络请求成功回调
    func responseSuccess()
    
    /// 网络请求失败回调
    func responseError(_ error: String)
    
    /// 网络请求成功，没有数据
    @objc optional func responseSuccess_noData()
    
    
    
    
    
    /// 上传token网络请求成功回调
    @objc optional func responseSuccess_uploadToken()
    
    /// 网络请求失败回调
    @objc optional func responseError_uploadToken(_ error: String)
    
    
    
    
    
//    /// 请求推送的新订单或公告
//    @objc optional func responseSuccess_requestPushNews()
//    
//    /// 网络请求失败回调
//    @objc optional func responseError_requestPushNews(_ error: String)
    
    
    
    
    //注释以下回调，为了静默设置红点
//    /// 设置推送消息状态（已读或未读，未读是0，已读是1）
//    @objc optional func responseSuccess_setPushMessageStatus(_ idx: String)
//    
//    /// 网络请求失败回调
//    @objc optional func responseError_setPushMessageStatus(_ error: String)
    
}





