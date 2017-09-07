//
//  Tools.swift
//  newDriver
//
//  Created by 凯东源 on 16/11/24.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class Tools: NSObject {

    
    /**
     * 显示对话框提示用户信息
     *
     * message 显示的信息
     */
    static func showAlertDialog (_ message: String, _ selfx : UIViewController) {
        
        let alert : UIAlertController = UIAlertController.init(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (UIAlertAction) in
        }))
        selfx.present(alert, animated: true, completion: nil)
    }
    
    
    static func twoDecimal (text : String) -> String {
        
        let textFloat = String(format: "%.2f", (text as NSString).floatValue)
        let str = "\(textFloat)"
        return str
    }
    
    /**
     根据 NSString width, 计算NSString高度
     
     @param text     文字
     @param fontSize 字体大小
     @param width    width
     
     @return NSString 高度
     */
    
    
    /// 根据 NSString width, 计算NSString高度
    ///
    /// - parameter text:     文字
    /// - parameter fontSize: 字体大小
    /// - parameter width:    width
    ///
    /// - returns: 高度
    static func getHeightOfString (text: String, fontSize: CGFloat, width:CGFloat) -> CGFloat {
        
        let label = UILabel.init()
        label.text = text
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.numberOfLines = 0;
        label.lineBreakMode = .byCharWrapping
        let sizeToFit = label.sizeThatFits(CGSize.init(width: width, height: CGFloat(MAXFLOAT)))
        return sizeToFit.height;
    }
}
