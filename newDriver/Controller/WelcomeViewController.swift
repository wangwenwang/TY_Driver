//
//  WelcomeViewController.swift
//  kdyDriver
//
//  Created by 凯东源 on 16/6/23.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    /// 是否自动跳转到登陆界面
    static var isShouldDoTimer: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if(UserDefaults.standard.bool(forKey: "firstStart") == false) {
//            //首次启动APP，使用凯东源启动页
//            addLogoAnimation()
//        } else {
            //非首次启动APP，使用怡宝启动页
            WelcomeViewController.isShouldDoTimer = true
            
            DispatchQueue.global().async {
//                sleep(2)
                DispatchQueue.main.async {
                    if WelcomeViewController.isShouldDoTimer {
                        self.performSegue(withIdentifier: "skipToLogin", sender: nil)
                    }
                }
//            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        WelcomeViewController.isShouldDoTimer = false
    }
    
    /// 旋转动画
    func addLogoAnimation() {
        let width : CGFloat = self.view.frame.width
        let heiht : CGFloat = self.view.frame.height
        
        //背景
        let bgView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: heiht))
        bgView.backgroundColor = UIColor.init(red: 240 / 255.0, green: 131 / 255.0, blue: 0 / 255.0, alpha: 1)
        self.view.addSubview(bgView)
        
        //LogoView
        let logo : UIImage = UIImage.init(named: "kdy")!
        let logoView : UIImageView = UIImageView.init(image: logo)
        let logoViewW = width / 1.5
        let logoViewH = logoViewW * (logo.size.height / logo.size.width)
        logoView.bounds = CGRect(x: 0, y: 0, width: logoViewW, height: logoViewH)
        logoView.center = CGPoint.init(x: width / 2, y: heiht / 2)
        self.view.addSubview(logoView)
        
        //旋转时间
        let duration : CFTimeInterval = 2.0
        
        //旋转动画
        let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z") //让其在z轴旋转
        rotationAnimation.toValue = NSNumber.init(value: M_PI * 2.0 as Double) //旋转角度
        rotationAnimation.duration = duration //旋转周期
        rotationAnimation.isCumulative = true //旋转累加角度
        rotationAnimation.repeatCount = 1 //旋转次数
        
        //缩放动画
        let scaleAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSNumber.init(value: 0.3 as Double)
        scaleAnimation.toValue = NSNumber.init(value: 0.95 as Double)
        scaleAnimation.duration = duration;
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        //群组动画
        let animationGroup : CAAnimationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.autoreverses = false   //是否重播，原动画的倒播
        animationGroup.repeatCount = 0  //HUGE_VALF;     //HUGE_VALF,源自math.h
        
        animationGroup.animations = NSArray.init(objects: rotationAnimation, scaleAnimation) as? [CAAnimation]
        
        //添加动画
        logoView.layer.add(animationGroup, forKey: "animationGroup")
        
        
        DispatchQueue.global().async {
            //动画
            usleep(UInt32(duration * 1000000 + 500000))
            DispatchQueue.main.async {
                if WelcomeViewController.isShouldDoTimer {
                    //去掉key动画
                    logoView.layer.removeAnimation(forKey: "animationGroup")
                    self.performSegue(withIdentifier: "skipToLogin", sender: nil)
                }
            }
        }
    }
}
