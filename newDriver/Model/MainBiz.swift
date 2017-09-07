//
//  MainBiz.swift
//  newDriver
//
//  Created by 凯东源 on 16/12/13.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class MainBiz: NSObject {
    
    /// 已交付订单集合
    var pushOrders: [PushOrder] = []
    
    /// 分页加载，正在加载的页数
    var tempPage: Int = 1
    
    /// 分页加载，已加载完的页数
    var page: Int = 1
    
    /// 分页条数
    let pageCount : Int! = 20
    
    /**
     * 请求已推送消息列表
     *
     * httpresponseProtocol: 网络请求协议
     */
    func requestPushNews(httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        
        if let user = AppDelegate.user {
            
            let parameters = [
                "strUserId": user.IDX,
                "strPage": String(tempPage),
                "strPageCount": String(pageCount),
                "strLicense": ""
            ]
            
            print(parameters)
            
            weak var weakSelf = self
            NetWorkBaseBiz().postWithPath(path: URLConstants.getPushMessage, paras: parameters, success: { (result) in
                DispatchQueue.main.async {
                    var dictReturn :NSDictionary? = nil
                    dictReturn = result as? NSDictionary
                    
                    if(dictReturn != nil) {
                        let json = JSON(dictReturn)
                        print("JSON: \(json)")
                        
                        
                        // 返回数据TYPE:0为订单;     1为公告
                        // 返回数据ISREAD:0为未读;   1为已读
                        if let wkSelf = weakSelf {
                            let type = json["type"].description
                            if type == "1" {
                                if wkSelf.tempPage == 1 {
                                    wkSelf.pushOrders.removeAll()
                                }
                                let list: Array<JSON> = json["result"].arrayValue
                                for json in list {
                                    let pushOrder: PushOrder = Mapper<PushOrder>().map(JSONString: json.description)!
                                    wkSelf.pushOrders.append(pushOrder)
                                }
                                wkSelf.page = wkSelf.tempPage
                                responseProtocol.responseSuccess()
                            } else if(type == "-2") {
                                responseProtocol.responseSuccess_noData!()
                            } else {
                                let msg = json["msg"].description
                                responseProtocol.responseError(msg)
                            }
                        }
                    }
                }
                }, failure: { (error) in
                    DispatchQueue.main.async {
                        responseProtocol.responseError("获取推送消息失败")
                        print(error)
                    }
            })
        }
    }
    
    /**
     * 请求已推送消息列表
     *
     * httpresponseProtocol: 网络请求协议
     */
    func setPushMessageStatus(newsId newsid: String, httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        let parameters = [
            "strIDX": newsid,
            "strLicense": ""
        ]
        
        weak var weakSelf = self
        NetWorkBaseBiz().postWithPath(path: URLConstants.setPushMessageStatus, paras: parameters, success: { (result) in
            DispatchQueue.main.async {
                var dictReturn :NSDictionary? = nil
                dictReturn = result as? NSDictionary
                
                if(dictReturn != nil) {
                    let json = JSON(dictReturn)
                    print("JSON: \(json)")
                    
                    let type = json["type"].description
                    if type == "1" {
                        let list: Array<JSON> = json["result"].arrayValue
                        print("list.count:\(list.count)")
                        if(list.count > 0) {
                            for json in list {
                                let pushOrder: PushOrder = Mapper<PushOrder>().map(JSONString: json.description)!
                                if let wkSelf = weakSelf {
                                    for pushOrder1 in wkSelf.pushOrders {
                                        if(pushOrder1.IDX == pushOrder.IDX) {
                                            pushOrder1.ISREAD = "1"
                                            break
                                        }
                                    }
                                }
                                //注释以下回调，为了静默设置红点
//                                DispatchQueue.main.async {
//                                    responseProtocol.responseSuccess_setPushMessageStatus!(pushOrder.IDX)
//                                }
                                break
                            }
                        } else {
                            //返回-1，表示不用在MainViewController的TableView设置已读
//                            responseProtocol.responseSuccess_setPushMessageStatus!("-1")
                        }
                    } else {
//                        let msg = json["msg"].description
//                        responseProtocol.responseError_setPushMessageStatus!(msg)
                    }
                }
            }
            }, failure: { (error) in
//                DispatchQueue.main.async {
//                    responseProtocol.responseError_setPushMessageStatus!("设置推送消息为已读状态失败")
//                    print(error)
//                }
        })
    }
}
