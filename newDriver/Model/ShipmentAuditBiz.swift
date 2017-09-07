//
//  ShipmentAuditStatusBiz.swift
//  newDriver
//
//  Created by 凯东源 on 17/3/23.
//  Copyright © 2017年 凯东源. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

class ShipmentAuditStatusBiz {
    
    /// 装运信息
    var shipmentInfo : ShipmentInfo? = nil
    
    /**
     * 获取装运信息
     *
     * shipmentNo:  装运编号
     *
     * httpresponseProtocol: 网络请求协议
     */
    func getShipmentData (shipmentNO shipmentNo: String, httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        let parameters = [
            "SHIPMENTNO": shipmentNo,
            "strLicense": ""
        ]
        
        weak var weakSelf = self
        NetWorkBaseBiz().postWithPath(path: URLConstants.kAPI_GetPrice, paras: parameters, success: { (result) in
            DispatchQueue.main.async {
                var dictReturn :NSDictionary? = nil
                dictReturn = result as? NSDictionary
                
                if(dictReturn != nil) {
                    let json = JSON(dictReturn)
                    print("JSON: \(json)")
                    
                    if let wkSelf = weakSelf {
                        let type = json["type"].description
                        if type == "1" {
                            let str = json["result"].description
                            if let or = Mapper<ShipmentInfo>().map(JSONString: str) {
                                
                                wkSelf.shipmentInfo = or
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
            }
        }) { (error) in
            DispatchQueue.main.async {
                
                responseProtocol.responseError("登陆失败")
                print(error)
            }
        }
    }
}
