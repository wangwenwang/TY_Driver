//
//  CheckPthBiz.swift
//  newDriver
//
//  Created by 凯东源 on 16/7/5.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class CheckPathBiz {
    
    
    /// 订单线路位置点集合
    var orderLocations: [Location] = []

    /**
     * 获取订单线路位置点集合
     *
     * orderIdx: 订单的 idx
     *
     * httpresponseProtocol: 网络请求协议
     */
    func getOrderLocaltions (orderIdx idx: String, httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        let parameters = [
            "strOrderId": idx,
            "strLicense": ""
        ]
        
        weak var wkSelf = self
        NetWorkBaseBiz().postWithPath(path: URLConstants.getOrderLoacations, paras: parameters, success: { (result) in
            DispatchQueue.main.async {
                var dictReturn :NSDictionary? = nil
                dictReturn = result as? NSDictionary
                
                if(dictReturn != nil) {
                    let json = JSON(dictReturn)
                    print("JSON: \(json)")
                    
                    let type = json["type"].description
                    if type == "1" {
                        wkSelf?.orderLocations = [Location]()
                        let list: Array<JSON> = json["result"].arrayValue
                        for js in list {
                            let location: Location =  Mapper<Location>().map(JSONString: js.description)!
                            location.CORDINATEY = (js["CORDINATEY"].description as NSString).doubleValue
                            location.CORDINATEX = (js["CORDINATEX"].description as NSString).doubleValue
                            wkSelf?.orderLocations.append(location)
                        }
                        responseProtocol.responseSuccess()
                    } else {
                        let msg = json["msg"].description
                        responseProtocol.responseError(msg)
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                responseProtocol.responseError("提交订单失败！")
                print(error)
            }
        }
        
//        Alamofire.request(URLConstants.getOrderLoacations, method: .post, parameters: parameters)
//            .responseJSON { response in
//                weak var wkSelf = self
//                switch response.result {
//                case .success:
//                    if let value = response.result.value {
//                        let json = JSON(value)
//                        print("JSON: \(json)")
//                        
//                        let type = json["type"].description
//                        if type == "1" {
//                            wkSelf?.orderLocations = [Location]()
//                            let list: Array<JSON> = json["result"].arrayValue
//                            for js in list {
//                                let location: Location =  Mapper<Location>().map(JSONString: js.description)!
//                                location.CORDINATEY = (js["CORDINATEY"].description as NSString).doubleValue
//                                location.CORDINATEX = (js["CORDINATEX"].description as NSString).doubleValue
//                                wkSelf?.orderLocations.append(location)
//                            }
//                            responseProtocol.responseSuccess()
//                        } else {
//                            let msg = json["msg"].description
//                            responseProtocol.responseError(msg)
//                        }
//                    }
//                case .failure(let error):
//                    responseProtocol.responseError("提交订单失败！")
//                    print(error)
//                }
//        }
    }
}
