//
//  OrderDetailBiz.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/28.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import Alamofire


class OrderDetailBiz {
    
    
    // 用来取消请求
    var LM:Alamofire.Request?
    
    /// 订单详情信息
    var order: Order?
    
    /**
     * 获取全部订单数据集合
     *
     * orderIDX: 订单的 idx
     *
     * httpresponseProtocol: 网络请求协议
     */
    func getOrderData (orderIDX idx: String, httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        let parameters = [
            "strTmsOrderId": idx,
            "strLicense": ""
        ]
        
        weak var weakSelf = self
//        NetWorkBaseBiz().postWithPath(path: URLConstants.getOrderTmsInfo, paras: parameters, success: { (result) in
//            DispatchQueue.main.async {
//                var dictReturn :NSDictionary? = nil
//                dictReturn = result as? NSDictionary
//                
//                if(dictReturn != nil) {
//                    let json = JSON(dictReturn)
//                    print("JSON: \(json)")
//                    
//                    if let wkSelf = weakSelf {
//                        let type = json["type"].description
//                        if type == "1" {
//                            let str = json["result"][0]["order"].description
//                            if let or = Mapper<Order>().map(JSONString: str) {
//                                wkSelf.order = or
//                                let orderDetailArray = json["result"][0]["order"]["OrderDetails"].arrayValue
//                                or.OrderDetails = []
//                                for detail in orderDetailArray {
//                                    or.OrderDetails.append(Mapper<OrderDetail>().map(JSONString: detail.description)!)
//                                }
//                                responseProtocol.responseSuccess()
//                            } else {
//                                responseProtocol.responseError("订单物流信息异常！")
//                            }
//                        } else {
//                            let msg = json["msg"].description
//                            responseProtocol.responseError(msg)
//                        }
//                    }
//                }
//            }
//        }) { (error) in
//            DispatchQueue.main.async {
//                responseProtocol.responseError("请求失败")
//                print(error)
//            }
//        }
        
                LM = Alamofire.request(URLConstants.getOrderTmsInfo, method: .post, parameters: parameters)
                    .responseJSON { response in
                        weak var weakSelf = self
                        switch response.result {
                        case .success:
                            if let value = response.result.value {
                                let json = JSON(value)
                                print("JSON: \(json)")
        
                                if let wkSelf = weakSelf {
                                    let type = json["type"].description
                                    if type == "1" {
                                        let str = json["result"][0]["order"].description
                                        if let or = Mapper<Order>().map(JSONString: str) {
                                            wkSelf.order = or
                                            let orderDetailArray = json["result"][0]["order"]["OrderDetails"].arrayValue
                                            or.OrderDetails = []
                                            for detail in orderDetailArray {
                                                or.OrderDetails.append(Mapper<OrderDetail>().map(JSONString: detail.description)!)
                                            }
                                            responseProtocol.responseSuccess()
                                        } else {
                                            responseProtocol.responseError("订单物流信息异常！")
                                        }
                                    } else {
                                        let msg = json["msg"].description
                                        responseProtocol.responseError(msg)
                                    }
                                }
                            }
                        case .failure(let error):
                            responseProtocol.responseError("请求失败")
                            print(error)
                        }
                }
    }
}
