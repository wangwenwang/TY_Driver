//
//  AppDelegateBiz.swift
//  newDriver
//
//  Created by 凯东源 on 16/12/10.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper



class AppDelegateBiz: NSObject {
    func uploadToken(strUserId userid: String, strCID cid: String, strToken token: String, httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        let parameters = [
            "strUserId": userid,
            "strCID": cid,
            "strToken": token,
            "strLicense": "",
            ]
        
//        print("即将上传token:\(parameters)")
        
        NetWorkBaseBiz().postWithPath(path: URLConstants.uploadToken, paras: parameters, success: { (result) in
            DispatchQueue.main.async {
                var dictReturn :NSDictionary? = nil
                dictReturn = result as? NSDictionary
                
                if(dictReturn != nil) {
                    let json = JSON(dictReturn)
                    print("JSON: \(json)")
                    
                    let type = json["type"].description
                    if type == "1" {
                        responseProtocol.responseSuccess_uploadToken!()
                    } else {
                        let msg = json["msg"].description
                        responseProtocol.responseError_uploadToken!(msg)
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                responseProtocol.responseError_uploadToken!("上传token失败！")
                print(error)
            }
        }
    }
}
