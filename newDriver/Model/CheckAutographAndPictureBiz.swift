//
//  CheckAutographAndPictureBiz.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper


class CheckAutographAndPictureBiz {
    
    
    /// 电子签名和现场图片集合
    var autographAndPicture = [OrderAutographAndPicture]()

    /**
     * 获取订单的电子签名和现场图片信息集合
     *
     * orderIDX: 订单的 idx
     *
     * httpresponseProtocol: 网络请求协议
     */
    func getOrderAutographAndPicture (orderIDX idx: String, httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        
        let parameters: [String: String] = [
            "strOrderIdx": idx,
            "strLicense": ""
        ]
        
        print(parameters)
        
        weak var weakSelf = self
        NetWorkBaseBiz().postWithPath(path: URLConstants.getAutographAndPicture, paras: parameters, success: { (result) in
            DispatchQueue.main.async {
                var dictReturn :NSDictionary? = nil
                dictReturn = result as? NSDictionary
                
                if(dictReturn != nil) {
                    let json = JSON(dictReturn)
                    print(json)
                    
                    if let wkSelf = weakSelf {
                        let type = json["type"].description
                        if type == "1" {
                            let arr = json["result"].arrayValue
                            wkSelf.autographAndPicture.removeAll()
                            for detail in arr {
                                let picture: OrderAutographAndPicture = Mapper<OrderAutographAndPicture>().map(JSONString: detail.description)!
                                wkSelf.autographAndPicture.append(picture)
                                responseProtocol.responseSuccess()
                            }
                        } else {
                            responseProtocol.responseError(json["msg"].description)
                        }
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                responseProtocol.responseError("获取订单签名、现场图片失败！")
                print(error)
            }
        }
        
//        Alamofire.request(URLConstants.getAutographAndPicture, method: .post, parameters: parameters)
//        .responseJSON { response in
//            weak var weakSelf = self
//            switch response.result {
//            case .success:
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    print(json)
//                    
//                    if let wkSelf = weakSelf {
//                        let type = json["type"].description
//                        if type == "1" {
//                            let arr = json["result"].arrayValue
//                            wkSelf.autographAndPicture.removeAll()
//                            for detail in arr {
//                                let picture: OrderAutographAndPicture = Mapper<OrderAutographAndPicture>().map(JSONString: detail.description)!
//                                wkSelf.autographAndPicture.append(picture)
//                                responseProtocol.responseSuccess()
//                            }
//                        } else {
//                            responseProtocol.responseError(json["msg"].description)
//                        }
//                    }
//                }
//            case .failure(let error):
//                responseProtocol.responseError("获取订单签名、现场图片失败！")
//                print(error)
//            }
//        }
    }
    
    
    /**
     * 获取图片的 url 路径
     *
     * remarkInt: 图片标记 （0 客户签名， 1 现场图片1， 2 现场图片2）
     *
     * return: 对应图片的网络 url
     */
    func getPictureUrl (_ remarkInt: Int) -> String {
        var i: Int = 1
        for picture in autographAndPicture {
            var productUrl = picture.PRODUCT_URL
            productUrl = URLConstants.loadUrl + URLConstants.serverAutographAndPictureFile + "/" + productUrl
            let remark: String = picture.REMARK
            if (picture.AUTOGRAPH == remark) && remarkInt == 0 {//为客户签名图片
                return productUrl
            } else if picture.PICTURE == remark {//为现场图片
                if (i == 1) && (remarkInt == 1) {
                    return productUrl
                } else if (i == 2) && (remarkInt == 2) {
                    return productUrl
                }
                i += 1
            }
        }
        return ""
    }
    
}
