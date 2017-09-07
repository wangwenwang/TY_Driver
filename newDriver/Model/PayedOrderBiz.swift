//
//  NotPayOrderBiz.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/27.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper


class PayedOrderBiz {
    
    /// 已交付订单集合
    var orders: [Order] = []
    
    /// 分页加载，正在加载的页数
    var tempPage: Int = 1
    
    /// 分页加载，已加载完的页数
    var page: Int = 1
    
    /**
     * 获取已交付订单数据集合
     *
     * httpresponseProtocol: 网络请求协议
     */
    func getPayedOrderData(httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        
        if let user = AppDelegate.user {
            
            let parameters = [
                "strUserIdx": user.IDX + "",
                "strIsPay": "Y",
                "strPage": "\(tempPage)",
                "strPageCount": "20",
                "strStartDate": "1990-05-12",
                "strEndDate": "2030-05-12",
                "strLicense": ""
            ]
            
            print(parameters)
            
            weak var weakSelf = self
            NetWorkBaseBiz().postWithPath(path: URLConstants.API_GetDriverDateOrderClientList, paras: parameters, success: { (result) in
                DispatchQueue.main.async {
                    var dictReturn :NSDictionary? = nil
                    dictReturn = result as? NSDictionary
                    
                    if(dictReturn != nil) {
                        let json = JSON(dictReturn)
                        print("JSON: \(json)")
                        
                        if let wkSelf = weakSelf {
                            let type = json["type"].description
                            if type == "1" {
                                if wkSelf.tempPage == 1 {
                                    wkSelf.orders.removeAll()
                                }
                                let list: Array<JSON> = json["result"].arrayValue
                                for json in list {
                                    let order: Order = Mapper<Order>().map(JSONString: json.description)!
                                    wkSelf.orders.append(order)
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
                        responseProtocol.responseError("获取已交付订单失败")
                        print(error)
                    }
            })
            
//            Alamofire.request(URLConstants.getDriverOrderList, method: .post, parameters: parameters)
//                .responseJSON { response in
//                    weak var weakSelf = self
//                    switch response.result {
//                    case .success:
//                        if let value = response.result.value {
//                            let json = JSON(value)
//                            print("JSON: \(json)")
//                            
//                            if let wkSelf = weakSelf {
//                                let type = json["type"].description
//                                if type == "1" {
//                                    if wkSelf.tempPage == 1 {
//                                        wkSelf.orders.removeAll()
//                                    }
//                                    let list: Array<JSON> = json["result"].arrayValue
//                                    for json in list {
//                                        let order: Order = Mapper<Order>().map(JSONString: json.description)!
//                                        wkSelf.orders.append(order)
//                                    }
//                                    wkSelf.page = wkSelf.tempPage
//                                    responseProtocol.responseSuccess()
//                                } else {
//                                    let msg = json["msg"].description
//                                    responseProtocol.responseError(msg)
//                                }
//                            }
//                        }
//                    case .failure(let error):
//                        responseProtocol.responseError("获取已交付订单失败")
//                        print(error)
//                    }
//            }
        }
    }
}
