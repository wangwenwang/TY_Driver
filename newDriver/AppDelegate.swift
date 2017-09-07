//
//  AppDelegate.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/25.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

import UserNotifications



let kGtAppId:String = "JYUaOhXe788SYPnicFy7i"
let kGtAppKey:String = "8v0FQopYNT8oWmdofIPAx6"
let kGtAppSecret:String = "922VP0bBym81XOxutQzVp1"



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate, GeTuiSdkDelegate,UNUserNotificationCenterDelegate {
    
    
    /// 登陆用户信息
    static var user: User?
    /// 顶部状态栏高度
    static var statusBarHeight: CGFloat = 20
    /// 当前坐标
    static var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    /// 通知cid
    static var cid : String! = ""
    /// 通知token
    static var token : String! = ""
    
    var window: UIWindow?
    
    static let TYColor: UIColor = UIColor.init(red: 48 / 255.0, green: 158 / 255.0, blue: 255 / 255.0, alpha: 1.0)
    
    /// 百度地图初始化用
    var baiduMapManager: BMKMapManager?
    
    
    func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        AppDelegate.statusBarHeight = newStatusBarFrame.height
    }
    
    //    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    //
    //        return true
    //    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        
        //百度地图设置
        baiduMapManager = BMKMapManager()
        let ret = baiduMapManager?.start("DKEddQWb471tGYaMMeLCqDXF2CBkqLmP", generalDelegate: self)
        if ret == false {
            NSLog("百度地图加载失败！")
        }
        
        //个推
        // [ GTSdk ]：是否允许APP后台运行
        //        GeTuiSdk.runBackgroundEnable(true)
        // [ GTSdk ]：是否运行电子围栏Lbs功能和是否SDK主动请求用户定位
        GeTuiSdk.lbsLocationEnable(true, andUserVerify: true)
        // [ GTSdk ]：自定义渠道
        GeTuiSdk.setChannelId("GT-Channel")
        // [ GTSdk ]：使用APPID/APPKEY/APPSECRENT启动个推
        GeTuiSdk.start(withAppId: kGtAppId, appKey: kGtAppKey, appSecret: kGtAppSecret, delegate: self)
        // 注册APNs - custom method - 开发者自定义的方法
        self.registerRemoteNotification()
        
        
        // 去掉返回按钮得字
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for: .default)
        
//        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 28),NSForegroundColorAttributeName: LM_blue]
        
        // 全局nav文字颜色
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:AppDelegate.TYColor]
        
        
        return true
    }
    
    // 清除通知栏和角标
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let udBadge : Int! = UserDefaults.standard.integer(forKey: "kApplicationIconBadgeNumber")
        
        if(udBadge != 0) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kMainViewController_reloadData"), object: nil)
        }
        print("clear bedge")
        application.applicationIconBadgeNumber = 0
        UserDefaults.standard.set(0, forKey: "kApplicationIconBadgeNumber")
        UserDefaults.standard.synchronize()
        application.cancelAllLocalNotifications()
        
    }
    
    //    func setk(_ value: Int, forKey defaultName: String) {
    //
    //    }
    //
    //
    //    func setk(_ value: Float, forKey defaultName: String) {
    //
    //    }
    
    // MARK: - 百度地图
    /// 百度地图获取网络连接状态
    func onGetNetworkState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("联网成功")
        }
        else{
            NSLog("联网失败，错误代码：Error\(iError)")
        }
    }
    
    /// 百度地图key是否正确能够连接
    func onGetPermissionState(_ iError: Int32) {
        if (0 == iError) {
            NSLog("授权成功")
        }
        else{
            NSLog("授权失败，错误代码：Error\(iError)")
        }
    }
    
    
    // MARK: - 用户通知(推送) _自定义方法
    /** 注册用户通知(推送) */
    func registerRemoteNotification() {
        /*
         警告：Xcode8的需要手动开启“TARGETS -> Capabilities -> Push Notifications”
         */
        
        /*
         警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。
         以下为演示代码，仅供参考，详细说明请参考苹果开发者文档，注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken。
         */
        
        let systemVer = (UIDevice.current.systemVersion as NSString).floatValue
        if systemVer >= 10.0 {
            if #available(iOS 10.0, *) {
                let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
                center.delegate = self
                center.requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { (granted:Bool, error:Error?) -> Void in
                    if (granted) {
                        print("注册通知成功") //点击允许
                    } else {
                        print("注册通知失败") //点击不允许
                    }
                })
                
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                let userSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(userSettings)
                
                UIApplication.shared.registerForRemoteNotifications()
            }
        }else if systemVer >= 8.0 {
            let userSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(userSettings)
            
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("didReceiveNotificationResponse: %@",response.notification.request.content.userInfo)
        
        // [ GTSdk ]：将收到的APNs信息传给个推统计
        GeTuiSdk.handleRemoteNotification(response.notification.request.content.userInfo)
        
        completionHandler()
    }
    
    
    
    
    
    
    // MARK: - 远程通知(推送)回调
    
    /** 远程通知注册成功委托 */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //为极光推送注册 token
        //        JPUSHService.registerDeviceToken(deviceToken)
        
        //个推
        let nsdataStr = NSData.init(data: deviceToken)
        var token = nsdataStr.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        token = token.replacingOccurrences(of: " ", with: "")
        // [ GTSdk ]：向个推服务器注册deviceToken
        GeTuiSdk.registerDeviceToken(token)
        UserDefaults.standard.set(token, forKey: "token")
        NSLog("\n>>>[DeviceToken Success]:%@\n\n",token)
        AppDelegate.token = token
    }
    
    /** 远程通知注册失败委托 */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //        print("did Fail To Register For Remote Notifications With Error = \(error)")
        print("\n>>>[DeviceToken Error]:%@\n\n",error.localizedDescription)
        
    }
    
    // MARK: - APP运行中接收到通知(推送)处理 - iOS 10 以下
    
    /** APP已经接收到“远程”通知(推送) - (App运行在后台/App运行在前台) */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //        JPUSHService.handleRemoteNotification(userInfo)
        print("didReceiveRemoteNotification")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //        print("didReceiveRemoteNotification,userInfo:\(userInfo.description)")
        //
        ////        JPUSHService.handleRemoteNotification(userInfo)
        //        completionHandler(UIBackgroundFetchResult.newData)
        
        
        
        // [ GTSdk ]：将收到的APNs信息传给个推统计
        GeTuiSdk.handleRemoteNotification(userInfo)
        
        NSLog("\n>>>[Receive RemoteNotification]:%@\n\n",userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        
        //application.applicationIconBadgeNumber有bug，还是用UserDefaults好了
        print("application.applicationIconBadgeNumber:\(application.applicationIconBadgeNumber)")
        
        let dict : Dictionary! = userInfo
        
        let anyBadge = dict["badge"]
        
        if let anyBadge1 = anyBadge {
            
            let strBadge : String! = anyBadge1 as? String
            if (strBadge) != nil {
                //                let iBadge : Int! = Int(strBadge)
                let udBadge : Int! = UserDefaults.standard.integer(forKey: "kApplicationIconBadgeNumber")
                let useBadge : Int! = udBadge + 1
                UserDefaults.standard.set(useBadge, forKey: "kApplicationIconBadgeNumber")
                UserDefaults.standard.synchronize()
                
                //有bug，手机会先设置1再设置+1，
                print("由于C#后台不能用+1，所以用穿透设置badge，\(useBadge)")
                DispatchQueue.main.async {
                    application.applicationIconBadgeNumber = useBadge
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("willPresentNotification: %@",notification.request.content.userInfo)
        
        completionHandler([.badge,.sound,.alert])
    }
    
    // MARK: - GeTuiSdkDelegate
    
    /** SDK启动成功返回cid */
    func geTuiSdkDidRegisterClient(_ clientId: String!) {
        // [4-EXT-1]: 个推SDK已注册，返回clientId
        NSLog("\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId)
        AppDelegate.cid = clientId
    }
    
    /** SDK遇到错误回调 */
    func geTuiSdkDidOccurError(_ error: Error!) {
        // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
        NSLog("\n>>>[GeTuiSdk error]:%@\n\n", error.localizedDescription)
    }
    
    /** SDK收到sendMessage消息回调 */
    func geTuiSdkDidSendMessage(_ messageId: String!, result: Int32) {
        // [4-EXT]:发送上行消息结果反馈
        let msg:String = "sendmessage=\(messageId),result=\(result)"
        NSLog("\n>>>[GeTuiSdk DidSendMessage]:%@\n\n",msg)
    }
    
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        
        var payloadMsg = ""
        if((payloadData) != nil) {
            payloadMsg = String.init(data: payloadData, encoding: String.Encoding.utf8)!
        }
        
        let msg:String = "Receive Payload: \(payloadMsg), taskId:\(taskId), messageId:\(msgId)"
        
        NSLog("\n>>>[GeTuiSdk DidReceivePayload]:%@\n\n",msg)
    }
}
