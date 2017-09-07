//
//  ChangePasswordViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/28.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, HttpResponseProtocol, UITextFieldDelegate {
    
    
    /// 更改密码的业务类
    let biz = ChangePasswordBiz()
    
    /// 用于记录用户当前编辑的文本框
    fileprivate var editTextField: UITextField?
    
    /// 原密码
    @IBOutlet weak var oldPasswordField: UITextField! {
        didSet {
            oldPasswordField.delegate = self
        }
    }
    
    /// 新密码
    @IBOutlet weak var newPasswordField: UITextField! {
        didSet {
            newPasswordField.delegate = self
        }
    }
    
    /// 重复确认新密码
    @IBOutlet weak var repeatPasswordField: UITextField! {
        didSet {
            repeatPasswordField.delegate = self
        }
    }
    
    /// 提交按钮
    @IBOutlet weak var changePasswordButtonField: UIButton!
    
    /// 网络请求时显示的进度条
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    /// 网络请求时显示的文本框
    @IBOutlet weak var progressfiels: UILabel!
    
    /// 提交修改密码
    @IBAction func changePassword(_ sender: UIButton) {
        
        if let oldpwd = oldPasswordField.text {
            
            if let newpwd = newPasswordField.text {
                
                if let repwd = repeatPasswordField.text {
                    
                    if newpwd.characters.count < 6 || repwd.characters.count < 6 {
                        
                        Tools.showAlertDialog("新密码不能小于六位数字或字母！", self)
                    } else {
                        
                        if newpwd == repwd {
                            
                            changePasswordButtonField.isEnabled = false
                            editTextField?.resignFirstResponder()
                            showProgress()
                            
                            //判断连接状态
                            let reachability = Reachability.forInternetConnection()
                            if reachability!.isReachable(){
                                biz.changePassword(oldPassword: oldpwd, newPassword: newpwd, httpresponseProtocol: self)
                            } else {
                                self.responseError("网络连接不可用!")
                            }
                        } else {
                            Tools.showAlertDialog("两次输入新密码不同！", self)
                        }
                    }
                } else {
                    Tools.showAlertDialog("请再次输入新密码确认！", self)
                }
            } else {
                Tools.showAlertDialog("请输入新密码！", self)
            }
        } else {
            Tools.showAlertDialog("请输入原密码！", self)
        }
    }
    
    /// 用户点击编辑框外的空间隐藏键盘
    @IBAction func click(_ sender: UITapGestureRecognizer) {
        if let textField = editTextField {
            textField.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        dismissProgress()
    }
    
    /// 修改登陆密码成功回调
    func responseSuccess() {
        Tools.showAlertDialog("修改密码成功！", self)
        changePasswordButtonField.isEnabled = true
        dismissProgress()
    }
    
    /**
     * 修改登陆密码失败回调方法
     *
     * message: 显示的信息
     */
    func responseError(_ error: String) {
        Tools.showAlertDialog(error, self)
        changePasswordButtonField.isEnabled = true
        dismissProgress()
    }
    
    /**
     * 记录用户正在编辑的文本框
     *
     * textField: 获取焦点的文本编辑框
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editTextField = textField
    }
    
    /**
     * 显示或者隐藏键盘
     *
     * textField: 获取焦点的文本编辑框
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /// 显示修改密码网络请求时显示的进度
    fileprivate func showProgress () {
        progress.startAnimating()
        progressfiels.text = "修改密码中。。。"
    }
    
    /// 隐藏修改密码网络请求时显示的进度
    fileprivate func dismissProgress () {
        progress.stopAnimating()
        progressfiels.text = ""
    }
}
