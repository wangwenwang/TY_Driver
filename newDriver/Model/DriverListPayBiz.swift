//
//  DriverListPayBiz.swift
//  newDriver
//
//  Created by 凯东源 on 2017/8/10.
//  Copyright © 2017年 凯东源. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper
import Alamofire

class DriverListPayBiz: NSObject {
    
    /**
     * 将 uiimage 对象转换成 base64 字符串
     *
     * image: 需要转换的图片
     *
     * return 转换完对应图片的 base64 字符串
     */
    func changeImageToString (_ image: UIImage?) -> String {
        if let im = image {
            let imageData = UIImagePNGRepresentation(im)
            if let data = imageData {
                return data.base64EncodedString(options: .lineLength64Characters)
            }
        }
        return ""
    }
    
    
    /**
     * 提交订单
     *
     * idx:              订单的 idx数组
     *
     * str:              签名图片的 base64 字符串
     *
     * str1:             现场图片1的 base64 字符串
     *
     * str2:             现场图片2的 base64 字符串
     *
     * str3:             回单单号
     *
     * responseProtocol: 网络请求协议
     */
    func payOrderWithPicture (orderIdx idx: String, autographStr str: String, image1Str str1: String, image2Str str2: String, deliveNoStr str3 : String, httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        
        let parameters = [
            "strOrdersIdx": idx,
            "AutographFile": str,
            "PictureFile1": str1,
            "PictureFile2": str2,
            "strDeliveNo" : str3,
            "strLicense": ""
        ]
        
        print(parameters)
        
        Alamofire.request(URLConstants.kAPI_DriverListPay, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let xxx):
                    print(xxx)
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json)")
                        
                        let type = json["type"].description
                        if type == "1" {
                            responseProtocol.responseSuccess()
                        } else {
                            let msg = json["msg"].description
                            responseProtocol.responseError(msg)
                        }
                    }
                case .failure(let error):
                    responseProtocol.responseError("提交订单失败！")
                    print(error)
                }
        }
    }
}
