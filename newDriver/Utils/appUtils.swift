//
//  appUtils.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation


class appUtils {

    /**
     * 获取 app 版本号
     *
     * return: app 版本号
     */
    static func getAppVersion () -> String {
        let infoDictionary = Bundle.main.infoDictionary
        if let info = infoDictionary {
            let version = info["CFBundleShortVersionString"]
            let vers = version as? String
            if let ver = vers {
                return ver
            }
        }
        return ""
    }
    
}
