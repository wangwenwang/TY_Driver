//
//  UIViewController+BackButtonHandler.swift
//  newDriver
//
//  Created by 凯东源 on 2017/8/14.
//  Copyright © 2017年 凯东源. All rights reserved.
//

import Foundation
import UIKit


protocol BackButtonHandlerProtocol {
    
    /// 网络请求成功回调
    func navigationShouldPopOnBackButton() -> Bool
}

extension UINavigationController:UINavigationBarDelegate, BackButtonHandlerProtocol {
    /// 网络请求成功回调
    internal func navigationShouldPopOnBackButton() -> Bool {
        
        return true
    }


    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        
        if(self.viewControllers.count < (navigationBar.items?.count)!) {
            
            return true
        }
        
        var shouldPop: Bool = true
        let vc: UIViewController = self.topViewController!
        if(vc.responds(to: #selector(navigationShouldPopOnBackButton))) {
            
            shouldPop = navigationShouldPopOnBackButton()
        }
        
        if(shouldPop) {
            
            DispatchQueue.main.async {
             
                self.popViewController(animated: true)
            }
        } else {
            
            for subview: UIView in navigationBar.subviews {
                
                if(0.0 < subview.alpha && subview.alpha < 1.0) {
                    
                    UIView.animate(withDuration: 0.25, animations: { 
                        
                        subview.alpha = 1.0
                    })
                }
            }
        }
        return true
    }}
