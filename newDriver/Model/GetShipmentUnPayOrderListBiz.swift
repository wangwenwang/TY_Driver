//
//  GetShipmentUnPayOrderListBiz.swift
//  newDriver
//
//  Created by 凯东源 on 2017/8/10.
//  Copyright © 2017年 凯东源. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

class GetShipmentUnPayOrderListBiz: NSObject {
    
    /// 未交付订单集合
    var orders: [Order] = []

    /**
     * 获取装运编号下属指定状态订单列表
     *
     * TMS_SHIPMENT_NO:  装运编号
     *
     * strIsPay:  订单状态
     *
     * httpresponse
     */
    func GetShipmentUnPayOrderList (andTMS_SHIPMENT_NO TMS_SHIPMENT_NO: String, andstrIsPay strIsPay:String, httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        let parameters = [
            "TMS_SHIPMENT_NO": TMS_SHIPMENT_NO,
            "strIsPay": strIsPay,
            "strLicense": ""
        ]
        
        weak var weakSelf = self
        NetWorkBaseBiz().postWithPath(path: URLConstants.kAPI_GetShipmentUnPayOrderList, paras: parameters, success: { (result) in
            DispatchQueue.main.async {
                var dictReturn :NSDictionary? = nil
                dictReturn = result as? NSDictionary
                
                if(dictReturn != nil) {
                    let json = JSON(dictReturn)
                    print("JSON: \(json)")
                    
                    if let wkSelf = weakSelf {
                        let type = json["type"].description
                        if type == "1" {
                            
                            let list: Array<JSON> = json["result"].arrayValue
                            for json in list {
                                let order: Order = Mapper<Order>().map(JSONString: json.description)!
                                wkSelf.orders.append(order)
                            }
                            responseProtocol.responseSuccess()
                        } else {
                            
                            let msg = json["msg"].description
                            responseProtocol.responseError(msg)
                        }
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                
                responseProtocol.responseError("登陆失败")
                print(error)
            }
        }
    }
}
