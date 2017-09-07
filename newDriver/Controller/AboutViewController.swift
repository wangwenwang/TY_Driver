//
//  AboutViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/8/5.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    var timer: Timer?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "关于"
        
        if timer == nil {
            if #available(iOS 10.0, *) {
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
                    
                    self.LM()
                })
            } else {
                // Fallback on earlier versions
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LM), userInfo: nil, repeats: true)
            }
        }
    }
    
    
    func LM() {
        
        print("LM")
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    
    deinit {
        
        print("deinit")
    }
}
