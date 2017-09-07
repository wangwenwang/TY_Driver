//
//  CheckVersionBiz.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper


class CheckVersionBiz {
    
    /// 最新版本的版本号
    var newAppVersion: String = ""
    
    /// 下载最新版本 app 的网络链接
    var downLoadUrl: String = ""

    /**
     * 获取 app 最新版本信息
     *
     * httpresponseProtocol: 网络请求协议
     */
    func getNewAppVersion (httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        //获取商店应用信息"http://itunes.apple.com/cn/lookup?id=应用id"

        
//        Alamofire.request(URLConstants.getAppVersionInfo, method: .post, parameters: nil)
//        .responseJSON { response in
//            weak var weakSelf = self
//            switch response.result {
//            case .success:
//                if let value = response.result.value {
//                    let json = JSON(value)
//                    print(json)
//                    
//                    if let wkSelf = weakSelf {
//                        let countNumber = NumberFormatter().number(from: json["resultCount"].description)
//                        let countInt = countNumber?.intValue
//                        if countInt! > 0 {
//                            let appUrl = json["results"][0]["trackViewUrl"].description
//                            wkSelf.downLoadUrl = appUrl
//                            wkSelf.newAppVersion = json["results"][0]["version"].description
//                            responseProtocol.responseSuccess()
//                        } else {
//                            responseProtocol.responseError("应用商店无此app信息！")
//                        }
//                    }
//                }
//            case .failure(let error):
//                responseProtocol.responseError("获取最新版本失败！")
//                print(error)
//            }
//        }
    }
}
