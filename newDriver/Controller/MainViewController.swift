//
//  MainViewController.swift
//  kdyDriver
//
//  Created by 凯东源 on 16/6/24.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, HttpResponseProtocol, BMKMapViewDelegate, BMKLocationServiceDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    // 顶部标题栏的高度
    static var natigationBarHeight: CGFloat?
    
    // 顶部标题栏的宽度
    static var natigationBarWidth: CGFloat?
    
    // 检查版本业务类
    fileprivate var checkVersionBiz = CheckVersionBiz()
    
    // 获取当前城市
    var _locationService: BMKLocationService!
    
    //    /// 提示信息对话框
    //    fileprivate var alertController = UIAlertView()
    //
    //    /// 提示用户升级对话框
    //    fileprivate var updateAppVersionAlert = UIAlertView()
    
    // 广告图片轮播控件
    @IBOutlet weak var cyclePictureViewContoner: UIView!
    
    // 资讯视图
    @IBOutlet weak var newsView: UIView!
    
    @IBOutlet weak var myTableView: UITableView!
    
    /// 请求推送消息
    let requestNewsBiz = MainBiz()
    
    var notificationType : String = "订单"
    
    /// 界面显示到前台的时候是否要刷新数据、登陆界面使用
    static var shouldRefresh: Bool = true
    
    var esRefreshFooterView : ESRefreshFooterView! = nil
    
    // MARK: - 生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "主页"
        DispatchQueue.global().async {
            usleep(300000)
            DispatchQueue.main.async {
                if MainViewController.shouldRefresh {
                    self.requestNewsBiz.tempPage = 1
                    self.myTableView.es_startPullToRefresh()
                    MainViewController.shouldRefresh = false
                }
            }
        }
        myTableView.reloadData()
        print("mainViewController.viewWillAppear")
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("mainViewController.viewDidAppear")
        
        if(CLLocationManager.authorizationStatus() != .denied) {
            print("应用拥有定位权限")
        }else {
            let infoDictionary = Bundle.main.infoDictionary
            let appDisplayName: AnyObject? = infoDictionary!["CFBundleDisplayName"] as AnyObject?
            let aleat = UIAlertController(title: "打开定位开关", message:"请打开系统设置中\"隐私->定位服务\",允许\(appDisplayName as! String)使用定位服务", preferredStyle: .alert)
            let tempAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            }
            let callAction = UIAlertAction(title: "立即设置", style: .default) { (action) in
                let url = NSURL.init(string: UIApplicationOpenSettingsURLString)
                if(UIApplication.shared.canOpenURL(url! as URL)) {
                    UIApplication.shared.openURL(url! as URL)
                }
            }
            aleat.addAction(tempAction)
            aleat.addAction(callAction)
            self.present(aleat, animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        MainViewController.natigationBarHeight = self.navigationController?.navigationBar.frame.height
        MainViewController.natigationBarWidth = self.navigationController?.navigationBar.frame.width
        
        addCycleView()
        
        //判断连接状态
        let reachability = Reachability.forInternetConnection()
        if reachability!.isReachable(){
            let userName: String = (AppDelegate.user?.USER_NAME)!
            print("\(userName)")
            if !(userName=="凯东源测试帐号") && !(userName=="15270949160") {
                // 审核时苹果提示需要苹果自己的更新机制，不允许app主动进行更新
                //                checkVersionBiz.getNewAppVersion(httpresponseProtocol: self)
            }
        } else{
            Tools.showAlertDialog("网络连接不可用!", self)
        }
        
        
        //注册Cell
        self.myTableView.register(UINib.init(nibName: "NotificationSimpleMsgTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationSimpleMsgTableViewCell")
        
        //初始化TableView
        initRefreshView()
        
        //注册通知
        registerForNotifications()
        
        // 获取当前城市
        startLocationService()
    }
    
    deinit {
        print("deinitMainViewVC")
        unregisterFromNotifications()
    }
    
    
    // MARK: - 功能函数
    func startLocationService() {
        _locationService = BMKLocationService.init()
        _locationService.delegate = self
        _locationService.startUserLocationService()
    }
    
    // MARK: - 函数
    /// 初始化显示未交付订单的上拉刷新河下拉加载的 tableview
    fileprivate func initRefreshView () {
        
        _ =  self.myTableView.es_addPullToRefresh {
            self.requestNewsBiz.tempPage = 1
            //判断连接状态
            let reachability = Reachability.forInternetConnection()
            if reachability!.isReachable(){
                self.requestNewsBiz.requestPushNews(httpresponseProtocol: self)
            }else{
                Tools.showAlertDialog("网络连接不可用!", self)
            }
        }
        
        self.myTableView.refreshIdentifier = NSStringFromClass(MainViewController.self) // Set refresh identifier
        self.myTableView.expriedTimeInterval = 20.0 // 20 second alive.
    }
    
    /// 添加广告轮播空间
    fileprivate func addCycleView () {
        self.cyclePictureViewContoner.layoutIfNeeded()
        let f = CGRect(x: 0, y: 0, width: self.view.frame.width + 5, height: cyclePictureViewContoner.bounds.height)
        let cyclePictureView = CyclePictureView(frame: f, imageURLArray: ["ad_pic_0","ad_pic_1", "ad_pic_2", "ad_pic_3"])
        cyclePictureView.timeInterval = 5.0
        cyclePictureViewContoner.addSubview(cyclePictureView)
    }
    
    func getDate(longDate: String) -> String {
        var shortDate: String! = ""
        
        shortDate = longDate.substring(from: longDate.index(longDate.endIndex, offsetBy: -14))
        shortDate = shortDate.substring(to: shortDate.index(shortDate.startIndex, offsetBy: 5))
        shortDate = shortDate.replacingOccurrences(of: "/", with: "-")
        
        
        return shortDate
    }
    
    
    func cutDate(longDate: String) -> String {
        var shortDate: String! = ""
        
        shortDate = longDate.substring(to: longDate.index(longDate.startIndex, offsetBy: longDate.characters.count - 3))
        
        return shortDate
    }
    
    
    // MARK: - 请求已推送数据回调
    func responseSuccess() {
        
        self.myTableView.reloadData()
        self.myTableView.es_stopPullToRefresh(completion: true)
        self.myTableView.es_stopLoadingMore()
        
        if esRefreshFooterView == nil {
            print("esRefreshFooterView == nil")
        } else {
            print("esRefreshFooterView != nil")
            print(esRefreshFooterView)
        }
        
        if(esRefreshFooterView == nil) {
            if(self.requestNewsBiz.pushOrders.count >= self.requestNewsBiz.pageCount) {
                esRefreshFooterView =  self.myTableView.es_addInfiniteScrolling {
                    //判断连接状态
                    let reachability = Reachability.forInternetConnection()
                    if reachability!.isReachable(){
                        self.requestNewsBiz.tempPage = self.requestNewsBiz.page + 1
                        self.requestNewsBiz.requestPushNews(httpresponseProtocol: self)
                    }else{
                        Tools.showAlertDialog("网络连接不可用!", self)
                    }
                }
            }
        } else {
            self.myTableView.noOrder(title: "暂无消息")
        }
        
        myTableView.removeNoOrderPrompt()
    }
    
    func responseError(_ error: String) {
        self.myTableView.reloadData()
        self.myTableView.es_stopPullToRefresh(completion: true)
        self.myTableView.es_stopLoadingMore()
        
        //        Tools.showAlertDialog(error, self)
    }
    
    func responseSuccess_noData() {
        self.myTableView.es_stopPullToRefresh(completion: true)
        if(esRefreshFooterView != nil) {
            self.myTableView.es_noticeNoMoreData()
            esRefreshFooterView.animator?.setloadingMoreDescription1("\(requestNewsBiz.pushOrders.count)")
        }
        
        if(requestNewsBiz.pushOrders.count == 0) {
            self.myTableView.es_stopLoadingMore()
            myTableView.noOrder(title: "您还没有消息")
        } else {
            myTableView.removeNoOrderPrompt()
        }
    }
    
    
//    // MARK: - 版本更新回调
//    /// 获取 app 版本信息成功回调
//    func responseSuccess() {
//        //        showUpdateAppDialog()
//    }
//    
//    /**
//     * 获取 app 版本信息失败回调
//     *
//     * error: 登陆失败原因
//     */
//    func responseError(_ error: String) {
//        
//        Tools.showAlertDialog(error, self)
//    }
    
    //    /**
    //     * 显示对话框提示用户信息
    //     *
    //     * message: 显示的信息
    //     */
    //    fileprivate func showAlertDialog (_ message: String) {
    //        alertController.message = message
    //        alertController.addButton(withTitle: "确定")
    //        alertController.cancelButtonIndex = 0
    //        alertController.show()
    //    }
    
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
    //            }
    //        }
    //    }
    //
    //    /**
    //     * 显示对话框提示用户是否升级回调方法
    //     *
    //     * alertView: 用户点击的 UIAlertView
    //     *
    //     * buttonIndex: 用户点击的 UIAlertView 中按钮的角标
    //     */
    //    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    //        if buttonIndex == 1 { //用户点击来确定按钮，跳转到商店下载界面
    //            let url = (URL(string: checkVersionBiz.downLoadUrl))!
    //            UIApplication.shared.openURL(url)
    //            print(url)
    //        }
    //    }
    //
    
    // MARK: - 点击事件
    @IBOutlet weak var cid: UITextField!
    
    @IBAction func cidOnclick(_ sender: UIButton) {
        cid.text = GeTuiSdk.clientId()
        cid.selectAll(self)
    }
    
    @IBAction func tokenOnclick(_ sender: UIButton) {
        cid.text = UserDefaults.standard.object(forKey: "token") as! String?
        cid.selectAll(sender)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let pushOrder: PushOrder = requestNewsBiz.pushOrders[(indexPath as NSIndexPath).row]
        
        if(pushOrder.TYPE == "0") {
            return 65
            
        } else if(pushOrder.TYPE == "1") {
            return 65
            
        } else {
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestNewsBiz.pushOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let pushOrder: PushOrder = requestNewsBiz.pushOrders[(indexPath as NSIndexPath).row]
        
        if(pushOrder.TYPE == "0") {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSimpleMsgTableViewCell", for: indexPath) as! NotificationSimpleMsgTableViewCell
            cell.titleLabel.text = pushOrder.SHIPMENTNO
            cell.dateLabel.text = cutDate(longDate: pushOrder.ADD_DATE)
            cell.typeTitleLabel.text = "装运编号"
            cell.typeIcon.image = UIImage.init(named: "ic_msg_notification")
            cell.badge.image = (pushOrder.ISREAD == "0") ? UIImage.init(named: "badge") : nil
            return cell
        } else if(pushOrder.TYPE == "1") {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSimpleMsgTableViewCell", for: indexPath) as! NotificationSimpleMsgTableViewCell
            cell.titleLabel.text = pushOrder.TITLE
            cell.dateLabel.text = pushOrder.ADD_DATE
            cell.typeTitleLabel.text = "公告"
            cell.typeIcon.image = UIImage.init(named: "ic_order_notification")
            cell.badge.image = (pushOrder.ISREAD == "0") ? UIImage.init(named: "badge") : nil
            return cell
        }
        
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myTableView.deselectRow(at: indexPath, animated: true)
        let pushOrder: PushOrder = requestNewsBiz.pushOrders[indexPath.row]
        
        if(pushOrder.TYPE == "0") {
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "PushOrderViewController") as! PushOrderViewController
            vc.SHIPMENT_List = pushOrder.SHIPMENT_List
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if(pushOrder.TYPE == "1") {
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
            vc.message = pushOrder.MESSAGE
            vc.title1 = pushOrder.TITLE
            self.navigationController?.pushViewController(vc, animated: true)
        }
        requestNewsBiz.setPushMessageStatus(newsId: pushOrder.IDX, httpresponseProtocol: self)
    }
    
    // MARK: - 设置已读状态回调
    //    func responseSuccess_setPushMessageStatus(_ idx: String) {
    //        //idx不等于-1，表示已经有消息被设置成已读，在biz层处理了
    //        if(idx != "-1") {
    ////            myTableView.reloadData()
    //        }
    //    }
    //
    //    func responseError_setPushMessageStatus(_ error: String) {
    //
    //    }
    
    // MARK: - Notificaiton
    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.reloadTableViewData), name: NSNotification.Name("kMainViewController_reloadData"), object: nil)
    }
    
    fileprivate func unregisterFromNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("kMainViewController_reloadData"), object: nil)
    }
    
    func reloadTableViewData() {
        self.requestNewsBiz.tempPage = 1
        //判断连接状态
        let reachability = Reachability.forInternetConnection()
        if reachability!.isReachable(){
            self.requestNewsBiz.requestPushNews(httpresponseProtocol: self)
        }else{
            self.responseError("网络连接不可用!")
        }
    }
    
    // MARK: - BMKLocationServiceDelegate
    func didUpdate(_ userLocation: BMKUserLocation!) {
        
        let geocoder: CLGeocoder = CLGeocoder.init()
        geocoder.reverseGeocodeLocation(userLocation.location) { (pls: [CLPlacemark]?, error: Error?) in
            if error == nil {
                guard let pl = pls?.first else {return}
                AppDelegate.user?.CITY = pl.locality!
                self._locationService.stopUserLocationService()
            }
        }
    }
}
