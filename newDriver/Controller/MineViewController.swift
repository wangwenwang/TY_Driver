//
//  MineTableViewController.swift
//  kdyDriver
//
//  Created by 凯东源 on 16/6/24.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class MineViewController: UIViewController, HttpResponseProtocol, UIAlertViewDelegate {
    
    
    /// 获取 app 版本信息业务类
    let checkVersionBiz = CheckVersionBiz()
    
//    /// 提示信息对话框
//    fileprivate var alertController = UIAlertView()
//    
//    /// 提示用户升级对话框
//    fileprivate var updateAppVersionAlert = UIAlertView()
    
    /// 用户姓名
    @IBOutlet weak var userNameField: UILabel!
    
    /// 用户角色
    @IBOutlet weak var userTypeField: UILabel!
    
    /// 版本号
    @IBOutlet weak var versionField: UILabel! {
        didSet {
            versionField.text = appUtils.getAppVersion()
        }
    }
    
    /// 跳转到修改密码界面
    @IBAction func skipToChangePassword(_ sender: UIButton) {
        self.navigationController?.pushViewController(ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil), animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "我的"
        if let user = AppDelegate.user {
            userNameField.text = user.USER_NAME
            userTypeField.text = user.USER_TYPE
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    /// 切换账号
    @IBAction func changeAccount(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 检查版本更新按钮
    @IBOutlet weak var checkVersionField: UIButton!
    
    /// 检查版本更新
    @IBAction func checkVersion(_ sender: UIButton) {
        checkVersionField.isEnabled = false
        //判断连接状态
        let reachability = Reachability.forInternetConnection()
        if reachability!.isReachable(){
            // 审核时苹果提示需要苹果自己的更新机制，不允许app主动进行更新
//            checkVersionBiz.getNewAppVersion(httpresponseProtocol: self)
        }else{
            responseError("网络连接不可用!")
        }
    }
    
    /// 跳转到关于界面
    @IBAction func about(_ sender: UIButton) {
        self.navigationController?.pushViewController(AboutViewController(nibName: "AboutViewController", bundle: nil), animated: true)
    }
    
    /// 获取 app 版本信息成功回调方法
    func responseSuccess() {
        self.checkVersionField.isEnabled = true
//        self.showUpdateAppDialog()
    }
    
    /**
     * 获取 app 版本信息失败回调方法
     *
     * message: 显示的信息
     */
    func responseError(_ error: String) {
            self.checkVersionField.isEnabled = true
            Tools.showAlertDialog(error, self)
    }
    
//    /// 提示用户是否升级
//    fileprivate func showUpdateAppDialog () {
//        let localAppVersion = appUtils.getAppVersion()
//        let newAppVersion = checkVersionBiz.newAppVersion
//        if !localAppVersion.isEmpty && !newAppVersion.isEmpty {
//            if localAppVersion != newAppVersion {
//                updateAppVersionAlert.title = "是否升级到最新版本"
//                updateAppVersionAlert.message = "当前版本："+localAppVersion + "\n" + "最新版本：" + newAppVersion
//                updateAppVersionAlert.delegate = self
//                
//                updateAppVersionAlert.addButton(withTitle: "取消")
//                updateAppVersionAlert.addButton(withTitle: "确定")
//                updateAppVersionAlert.cancelButtonIndex = 0
//                
//                updateAppVersionAlert.show()
//            } else {
//                showAlertDialog("当前已是最新版本！")
//                checkVersionField.isEnabled = true
//            }
//        }
//    }
    
//    /**
//     * 显示对话框提示用户是否升级回调方法
//     *
//     * alertView: 用户点击的 UIAlertView
//     *
//     * buttonIndex: 用户点击的 UIAlertView 中按钮的角标
//     */
//    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
//        if buttonIndex == 1 { //用户点击来确定按钮，跳转到商店下载界面
//            let url = (URL(string: checkVersionBiz.downLoadUrl))!
//            UIApplication.shared.openURL(url)
//            print(url)
//        }
//    }

}


















