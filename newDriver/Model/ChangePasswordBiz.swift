//
//  ChangePasswordBiz.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/28.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper


class ChangePasswordBiz {

    
    /**
     * 更改登陆密码
     *
     * oldPassword: 原密码
     *
     * newPassword: 新密码
     *
     * httpresponseProtocol: 网络请求协议
     */
    func changePassword (oldPassword oldpwd: String, newPassword newpwd:String, httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        if let userName = AppDelegate.user?.USER_CODE {
            print("userName:\(userName)")
            let parameters = [
                "strUserName": userName,
                "strPassword": oldpwd,
                "strNewPassword": newpwd,
                "strLicense": ""
            ]
            
            NetWorkBaseBiz().postWithPath(path: URLConstants.changePassword, paras: parameters, success: { (result) in
                DispatchQueue.main.async {
                    var dictReturn :NSDictionary? = nil
                    dictReturn = result as? NSDictionary
                    
                    if(dictReturn != nil) {
                        let json = JSON(dictReturn)
                        print("JSON: \(json)")
                        
                        let type = json["type"].description
                        if type == "1" {
                            responseProtocol.responseSuccess()
                        } else {
                            let msg = json["msg"].description
                            responseProtocol.responseError(msg)
                        }
                    }
                }
                }, failure: { (error) in
                    DispatchQueue.main.async {
                        responseProtocol.responseError("修改密码失败！")
                        print(error)
                    }
            })
            
//            Alamofire.request(URLConstants.changePassword, method: .post, parameters: parameters)
//                .responseJSON { response in
//                    switch response.result {
//                    case .success:
//                        if let value = response.result.value {
//                            let json = JSON(value)
//                            print("JSON: \(json)")
//                        
//                            let type = json["type"].description
//                            if type == "1" {
//                                responseProtocol.responseSuccess()
//                            } else {
//                                let msg = json["msg"].description
//                                responseProtocol.responseError(msg)
//                            }
//                        }
//                    case .failure(let error):
//                        responseProtocol.responseError("修改密码失败！")
//                        print(error)
//                    }
//            }
        }
    }
}
