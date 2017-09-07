//
//  LoginViewController.swift
//  kdyDriver
//
//  Created by 凯东源 on 16/6/23.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, HttpResponseProtocol, BMKLocationServiceDelegate {
    
    
    /// 记录用户最近坐标
    fileprivate var location: CLLocationCoordinate2D?
    
    /// 计时器，固定间隔时间上传位置信息
    fileprivate var localTimer: Timer!
    
    /// 用户位置是否有更新
    fileprivate var isUpdataLocation: Bool = true
    
    /// 百度地图定位服务
    fileprivate var localService: BMKLocationService!
    
    /// 用户名
    @IBOutlet weak var userName: UITextField! {
        didSet {
            userName.delegate = self
            if let name = UserDefaults.standard.value(forKey: BusinessConstants.userName) as? String {
                userName.text = name
            }
        }
    }
    
    /// 用户密码
    @IBOutlet weak var password: UITextField! {
        didSet {
            password.delegate = self
            password.isSecureTextEntry = true
            if let pwd = UserDefaults.standard.value(forKey: BusinessConstants.passWord) as? String {
                password.text = pwd
            }
        }
    }
    
    /// 登陆按钮
    @IBOutlet weak var loginButton: UIButton!
    
    /// 登陆时转圈圈
    @IBOutlet weak var progress: UIActivityIndicatorView! {
        didSet {
            progress.hidesWhenStopped = true
        }
    }
    
    /// 显示登陆状态文本框
    @IBOutlet weak var showText: UILabel!
    
    /// 用于记录用户当前编辑的文本框
    fileprivate var editTextField: UITextField?
    
    /// 登陆业务类
    fileprivate var biz = LoginBiz()
    
    /// 上传token
    fileprivate var bizToken = AppDelegateBiz()
    
    /// 用户点击登陆按钮，登陆
    @IBAction func login(_ sender: UIButton) {
        login()
    }
    
    /// 登陆，发送请求到后台
    fileprivate func login () {
        if let name  = userName.text {
            if !name.isEmpty {
                if let pwd = password.text {
                    if !pwd.isEmpty {
                        loginButton.isEnabled = false
                        showLoginField()
                        editTextField?.resignFirstResponder()
                        
                        //判断连接状态
                        let reachability = Reachability.forInternetConnection()
                        if reachability!.isReachable(){
                            biz.login(userName: name, password: pwd, httpresponseProtocol: self)
                            
//                            bizToken.uploadToken(strUserId: (AppDelegate.user?.IDX)!, strCID: AppDelegate.cid, strToken: AppDelegate.token, httpresponseProtocol: self)
                            
                            
//                            bizToken.uploadToken(strUserId: "", strCID: "", strToken: "", httpresponseProtocol: self)
                        }else{
                            responseError("网络连接不可用!")
                        }
                    } else {
                        Tools.showAlertDialog("请输入密码！", self)
                    }
                } else {
                    Tools.showAlertDialog("请输入密码！", self)
                }
            } else {
                Tools.showAlertDialog("请输入用户名！", self)
            }
        } else {
            Tools.showAlertDialog("请输入用户名！", self)
        }
    }
    
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dismissLoginField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "登陆"
    }
    
    
    deinit {
        
        print("loginVC deinit")
    }
    
    
    // MARK: - 事件
    // 用户点击事件
    @IBAction func downAction(_ sender: UITapGestureRecognizer) {
        if let textField = editTextField {//用户点击编辑框外的空间隐藏键盘
            textField.resignFirstResponder()
        }
    }
    
    /**
     * 记录用户正在编辑的文本框
     *
     * textField 得到焦点的文本编辑框
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        editTextField = textField
    }
    
    /**
     * 显示或隐藏键盘
     *
     * textField 得到焦点的文本编辑框
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - 功能函数
    // 显示登陆时的进度
    func showLoginField () {
        showText.text = "登陆中。。。"
        progress.startAnimating()
    }
    
    
    // 隐藏登陆时的进度
    func dismissLoginField () {
        showText.text = ""
        progress.stopAnimating()
    }
    
    
    fileprivate func startLocationService () {
        // 初始化BMKLocationService
        localService = BMKLocationService()
        // 启动LocationService
        localService.startUserLocationService()
        // 设置定位精度
        localService.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // 指定最小距离更新(米)，默认：kCLDistanceFilterNone
        localService.distanceFilter = 500
        // 指定最小更新角度
        localService.headingFilter = 270
        localService.delegate = self
        if #available(iOS 9.0, *) {
            localService.allowsBackgroundLocationUpdates = true
        }
        localService.pausesLocationUpdatesAutomatically = false
    }
    
    
    // MARK: - 登陆回调
    // 登陆成功回调
    func responseSuccess() {
        
        DispatchQueue.global().async {
            
            while (AppDelegate.cid == ""){
                let dealyTime : Int = 2
                print("cid为空，延迟\(dealyTime)秒调用上传token函数")
                sleep(2)
            }
            
            self.bizToken.uploadToken(strUserId: (AppDelegate.user?.IDX)!, strCID: AppDelegate.cid, strToken: AppDelegate.token, httpresponseProtocol: self)
            
        }
        
        title = ""
        NotPayTableViewController.shouldRefresh = true
        PayedTableViewController.shouldRefresh = true
        AllTableViewController.shouldRefresh = true
        MainViewController.shouldRefresh = true
        loginButton.isEnabled = true
        dismissLoginField()
        startLocationService()
        startUpdataLocationTimer()
        UserDefaults.standard.setValue(true, forKey: "firstStart")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "Skip To Main", sender: nil)
    }
    
    /**
     * 登陆失败回调方法
     *
     * error 登陆失败原因
     */
    func responseError(_ error: String) {
        loginButton.isEnabled = true
        dismissLoginField()
        Tools.showAlertDialog(error, self)
    }
    
    // MARK: - 上传token回调
    func responseSuccess_uploadToken() {
        print("上传token成功")
    }
    
    func responseError_uploadToken(_ error: String) {
        Tools.showAlertDialog(error, self)
    }
    
//    /**
//     * 显示对话框提示用户信息
//     *
//     * message 显示的信息
//     */
//    fileprivate func showAlertDialog (_ message: String) {
// 
//        let alert : UIAlertController = UIAlertController.init(title: message, message: "", preferredStyle: .alert)
//        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (UIAlertAction) in
//        }))
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
    // MARK: - BMKLocationServiceDelegate
    // 位置坐标发生改变
    func didUpdate(_ userLocation: BMKUserLocation!) {
        location = userLocation.location.coordinate
        isUpdataLocation = true
        if biz.isNeedChangeUpdataLocationSpanTime {//上传位置点间隔时间需要进行调整
            print("更改上传位置点间隔时间：更改为\(biz.updataLocationSpanTimeMin)分钟")
            startUpdataLocationTimer()
            biz.isNeedChangeUpdataLocationSpanTime = false
        }
        
        //记录最新的位置
        AppDelegate.location = userLocation.location.coordinate
    }
    
    
    // MARK: - 定时器
    // 开启间隔时间上传位置点计时器
    fileprivate func startUpdataLocationTimer () {
        if localTimer != nil {
            localTimer.invalidate()
            print("关闭定时上传位置点信息计时器")
        }
        
        #if DEBUG
            localTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(LoginViewController.updataLocation(_:)), userInfo: nil, repeats: true)
        #else
            localTimer = Timer.scheduledTimer(timeInterval: biz.updataLocationSpanTimeMin * 60, target: self, selector: #selector(LoginViewController.updataLocation(_:)), userInfo: nil, repeats: true)
        #endif
        print("开启定时上传位置点信息计时器")
    }
    
    // 测试用来查看上传多少条记录，无实用功能
    var i: Int = 0
    // 上传位置信息
    func updataLocation (_ timer: Timer) {
        print("上传位置点信息！\(i)")
        i += 1
        if let lo = location {
            if isUpdataLocation {
                //判断连接状态
                let reachability = Reachability.forInternetConnection()
                
                #if DEBUG
                    print("dubug模式，不上传位置信息")
                #else
                    if reachability!.isReachable(){
                        biz.updataLocation(lo)
                    }else{
                        biz.saveLocationPointInLocal(lo)
                    }
                    isUpdataLocation = false
                #endif
            }
        }
    }
}
