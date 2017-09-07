//
//  FileUtils.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation


class FileUtils {

    /**
     * 删除文件
     *
     * filePath: 文件路径
     */
    static func deleteFile (_ filePath: String) {
        let fileManager = FileManager.default
        try! fileManager.removeItem(atPath: filePath)
    }
    
}
