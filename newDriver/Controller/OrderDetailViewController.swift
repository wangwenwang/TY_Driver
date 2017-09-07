//
//  OrderDetailViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/27.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit
import MapKit


/// 已交付状态
let kDRIVER_PAY_YES = "已交付"

/// 未交付状态
let kDRIVER_PAY_NO = "未交付"

/// 计费状态
let kCheckBillingStatus_YES = "已计费"
let kCheckBillingStatus_NO = "未计费"
let kCheckBillingStatus_CARSH = "计费异常"



class OrderDetailViewController: UIViewController, HttpResponseProtocol, UITableViewDelegate, UITableViewDataSource, BMKGeoCodeSearchDelegate, MBProgressHUDDelegate, BMKMapViewDelegate {
    
    // 地址转坐标时，由let flag : Bool = searcher.geoCode(geoCodeSearchOption) 发出检索后，如果onGetGeoCodeResult回调还没执行就销毁控制器程序会崩溃
    var timer: Timer?
    
    /// HUD
    var HUD: MBProgressHUD?
    
    /// 用户的 idx
    var orderIDX: String?
    
    /// 订单详情业务类
    var biz: OrderDetailBiz = OrderDetailBiz()
    
    /// 订单编号
    @IBOutlet weak var orderNumber: UILabel!
    
    /// 客户订单编号
    @IBOutlet weak var ORD_NO_CLIENT: UILabel!
    
    /// 装运编号
    @IBOutlet weak var orderShipmentNumber: UILabel!
    
    /// 装运时间
    @IBOutlet weak var orderLoadDate: UILabel!
    
    /// 出库时间
    @IBOutlet weak var orderIssueDate: UILabel!
    
    /// 承运商名
    @IBOutlet weak var orderFleetName: UILabel!
    
    /// 车牌号码
    @IBOutlet weak var orderPlateNumber: UILabel!
    
    /// 司机姓名
    @IBOutlet weak var orderDriverName: UILabel!
    
    /// 司机号码
    @IBOutlet weak var orderDriverTelephone: UILabel!
    
    /// 订单状态
    @IBOutlet weak var orderState: UILabel!
    
    /// 订单流程
    @IBOutlet weak var orderWorkFlow: UILabel!
    
    /// 交付状态
    @IBOutlet weak var orderPayState: UILabel!
    
    /// 订单数量
    @IBOutlet weak var orderIssueQty: UILabel!
    
    /// 订单重量
    @IBOutlet weak var orderIssueWeight: UILabel!
    
    /// 订单体积
    @IBOutlet weak var orderIssueVolume: UILabel!
    
    /// 客户名称
    @IBOutlet weak var orderToName: UILabel!
    
    /// 出货地点
    @IBOutlet weak var orderFromeName: UILabel!
    
    /// 目的地点
    @IBOutlet weak var orderToAddress: UILabel!
    
    // 货物信息
    @IBOutlet weak var orderDetailsTableView: UITableView! {
        didSet {
            orderDetailsTableView.delegate = self
            orderDetailsTableView.dataSource = self
        }
    }
    
    // 请求数据时显示的圈圈
    @IBOutlet weak var progressField: UIActivityIndicatorView!
    
    // 网络请求时显示的界面，覆盖数据显示界面
    @IBOutlet weak var loadingViewField: UIView!
    
    // 底部按钮容器
    @IBOutlet weak var buttonViewContioner: UIView!
    
    // 导航 或 查看路线
    @IBOutlet weak var navigationOrCheckPathBtn: UIButton!
    
    // 交付订单 或 查看图片
    @IBOutlet weak var deliverOrCheckPictureBtn: UIButton!
    
    // 查看计费
    @IBOutlet weak var checkBillingBtn: UIButton!
    
    let cellIdentifier = "OrderDetailsTableViewCell"
    
    // 第一按钮宽度
    @IBOutlet weak var oneBtn_width: NSLayoutConstraint!
    
    // 第二个按钮宽度
    @IBOutlet weak var twoBtn_width: NSLayoutConstraint!
    
    // 第三个按钮宽度
    @IBOutlet weak var threeBtn_width: NSLayoutConstraint!
    
    // 第二个按钮与第三个按钮之间的宽度
    @IBOutlet weak var twoThree_width: NSLayoutConstraint!
    
    // 检索对象
    let searcher : BMKGeoCodeSearch = BMKGeoCodeSearch()
    
    let geoCodeSearchOption : BMKGeoCodeSearchOption = BMKGeoCodeSearchOption()
    
    var bmkGeoCodeResult : BMKGeoCodeResult = BMKGeoCodeResult()
    
    var maps = Array<String>()
    
    var pointAnnotation: BMKPointAnnotation?
    
    var currentMapType : String!
    
    var coordinate2D_GaoDe : CLLocationCoordinate2D!
    
    var addressF : UITextField!
    
    var ord_to_address : String = ""
    
    /// 是否已经pop控制器，因为网络请求还在而不释放bug
    var isPopVC : Bool = false
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.orderDetailsTableView.register(UINib.init(nibName: "OrderDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        showLoading()
        if let idx = orderIDX {
            //判断连接状态
            let reachability = Reachability.forInternetConnection()
            if reachability!.isReachable(){
                
                //                idx = "430889" // 有计费异常
                //                idx = "47795"  // 已计费
                
                //                if idx == "337484" {idx = "47795"}
                biz.getOrderData(orderIDX: idx, httpresponseProtocol: self)
            }else{
                self.responseError("网络连接不可用!")
            }
        }
    }
    
    func LM() {
        
        print("延迟释放控制器LM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        self.title = "物流信息"
        isPopVC = false
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        print("i m viewDidAppear")
        
        //        self.setButtonTitle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        print("i m viewDidDisappear")
        isPopVC = true
        biz.LM?.cancel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("i m viewWillDisappear")
        isPopVC = true
    }
    
    deinit {
        print("deinitDetail")
    }
    
    // MARK: - BMKGeoCodeSearchDelegate
    //实现Deleage处理回调结果
    //接收正向编码结果
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
        timer?.invalidate()
        
        if (error == BMK_SEARCH_NO_ERROR) {
            //在此处理正常结果
            bmkGeoCodeResult = result
            //跳到百度地图也需要坐标转换
            coordinate2D_GaoDe = bdToGaoDe(bmkGeoCodeResult.location)
            
            if((HUD != nil)) {
                // UIImageView is a UIKit class, we have to initialize it on the main thread
                var imageView: UIImageView?;
                let image: UIImage? = UIImage(named: "37x-Checkmark.png")
                imageView = UIImageView(image: image)
                HUD!.customView = imageView
                HUD!.mode = .customView
                HUD?.labelText = "目的地址已确定，即将进入地图微调"
                
                HUD?.hide(true, afterDelay: 4.0)
                HUD = nil
                
                DispatchQueue.global().async {
                    sleep(5)
                    DispatchQueue.main.async {
                        let vc = CheckAndModifyOrderAddressViewController()
                        vc._coordinate = self.bmkGeoCodeResult.location
                        vc._coordinate_GaoDe = self.coordinate2D_GaoDe
                        vc._address = self.ord_to_address
                        vc._mapName = self.currentMapType
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
            
            orderToAddress.text = biz.order?.ORD_TO_ADDRESS
        }
        else {
            NSLog("抱歉，未找到结果");
            if((HUD != nil)) {
                // UIImageView is a UIKit class, we have to initialize it on the main thread
                var imageView: UIImageView?;
                let image: UIImage? = UIImage(named: "37x-CheckmarkNO.png")
                imageView = UIImageView(image: image)
                HUD!.customView = imageView
                HUD!.mode = .customView
                HUD?.labelText = "未找到目的地址，请再次修改地址"
                HUD?.hide(true, afterDelay: 4.0)
            }
        }
    }
    
    // MARK: - 功能方法
    func mapsSheet (_ maps : [String]) {
        
        let actionSheetC : UIAlertController = UIAlertController.init(title: "选择地图", message: "", preferredStyle: .actionSheet)
        
        actionSheetC.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        
        for index in 0..<maps.count {
            actionSheetC.addAction(UIAlertAction.init(title: maps[index], style: .default, handler: { (UIAlertAction) in
                
                self.toMaps(maps[index])
                self.currentMapType = maps[index]
            }))
        }
        
        self.present(actionSheetC, animated: true, completion: nil)
    }
    
    //通过地址转成坐标
    func getGeoCode() {
        //初始化检索对象
        searcher.delegate = self
        geoCodeSearchOption.city = AppDelegate.user?.CITY
        let xxx : String = (biz.order?.ORD_TO_ADDRESS)!
        print("过滤前目的城市:\(xxx)")
        
        //过滤*号
        if let ORD_TO_ADDRESS = biz.order?.ORD_TO_ADDRESS {
            ord_to_address = ORD_TO_ADDRESS.replacingOccurrences(of: "*", with: "")
        }
        
        //算了，不过滤吧，百度api会自动过滤一些
        //        //过滤地址的补充
        //        let a : Array = ord_to_address.components(separatedBy: "(")
        //        if (a.count > 1) {
        //            ord_to_address = a[0]
        //        } else {
        //            let b : Array = ord_to_address.components(separatedBy: "（")
        //            if(b.count > 1) {
        //                ord_to_address = b[0]
        //            }
        //        }
        
        
        
        // 延迟释放控制器
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
        
        geoCodeSearchOption.address = ord_to_address
        let flag : Bool = searcher.geoCode(geoCodeSearchOption)
        if(flag) {
            NSLog("geo检索发送成功");
        }
        else {
            NSLog("geo检索发送失败");
        }
    }
    
    fileprivate func bdToGaoDe (_ location : CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let bd_lat : Double = location.latitude
        let bd_lon : Double = location.longitude
        var gd_lat_lon : [Double] = [0, 0]
        let PI : Double = 3.14159265358979324 * 3000.0 / 180.0
        let x : Double = bd_lon - 0.0065, y = bd_lat - 0.006
        let z : Double =  sqrt(x * x + y * y) - 0.00002 * sin(y * PI)
        let theta : Double =  atan2(y, x) - 0.000003 * cos(x * PI)
        gd_lat_lon[0] = z * cos(theta)
        gd_lat_lon[1] = z * sin(theta)
        return CLLocationCoordinate2DMake(gd_lat_lon[1], gd_lat_lon[0])
    }
    
    /// 显示获取订单详情数据时显示的进度
    fileprivate func showLoading () {
        progressField.startAnimating()
        loadingViewField.alpha = 1.0
    }
    
    /// 隐藏获取订单详情数据时显示的进度
    fileprivate func dismissLoading () {
        progressField.stopAnimating()
        loadingViewField.alpha = 0.0
    }
    
    func toMaps(_ name : String) {
        if(coordinate2D_GaoDe == nil) {
            
            let alert : UIAlertController = UIAlertController.init(title: "终点不确定,请修正", message: "例如：补全城市名等", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction.init(title: "取消", style: .default, handler: { (UIAlertAction) in
                print("取消修正地址")
            }))
            
            alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (UIAlertAction) in
                let address : String = self.addressF.text!
                print("修正后的地址：\(address)")
                //填充默认值
                self.biz.order?.ORD_TO_ADDRESS = address
                
                self.HUD = MBProgressHUD(view: self.navigationController!.view)
                self.navigationController!.view.addSubview(self.HUD!)
                
                self.HUD!.delegate = self
                self.HUD!.labelText = "正在修改终点地址..."
                self.HUD?.show(true)
                
                self.getGeoCode()
            }))
            
            alert.addTextField(configurationHandler: { (UITextField) in
                self.addressF = UITextField
                UITextField.text = self.biz.order?.ORD_TO_ADDRESS
            })
            
            self.present(alert, animated: true, completion: nil)
            
            return;
        }
        if(name == "苹果自带地图") {
            
            print("苹果自带地图")
            let currentLocation : MKMapItem = MKMapItem.forCurrentLocation()
            let toLocation : MKMapItem = MKMapItem.init(placemark: MKPlacemark.init(coordinate: coordinate2D_GaoDe, addressDictionary: nil))
            toLocation.name = biz.order?.ORD_TO_ADDRESS
            MKMapItem.openMaps(with: [currentLocation, toLocation], launchOptions:[MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey : NSNumber.init(value: false as Bool)])
            
        } else if(name == "高德地图") {
            
            print("高德地图")
            var urlString: String = "iosamap://path?sourceApplication=配货易(司机)&sid=BGVIS1&slat=&slon=&sname=&did=BGVIS2&dlat=\(coordinate2D_GaoDe.latitude)&dlon=\(coordinate2D_GaoDe.longitude)&dname=\(ord_to_address)&dev=0&t=0"
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                UIApplication.shared.openURL(URL(string: urlString)!)
        } else if(name == "百度地图") {
            
            print("百度地图")
            var urlString : String = "baidumap://map/direction?destination=\(ord_to_address)&mode=driving&coord_type=gcj02"
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            UIApplication.shared.openURL(URL(string: urlString)!)
            
        } else if(name == "谷歌地图") {
            
            Tools.showAlertDialog("正在建设中...", self)
            print("谷歌地图")
        }
        
        print("传出坐标:\(coordinate2D_GaoDe)")
    }
    
    
    // 订单是否已交付
    func DRIVER_PAY() -> String {
        
        if !(biz.order?.DRIVER_PAY.isEmpty)! && biz.order?.DRIVER_PAY == kDRIVER_PAY_YES {
            
            return kDRIVER_PAY_YES
        } else if !(biz.order?.DRIVER_PAY.isEmpty)! && biz.order?.DRIVER_PAY == kDRIVER_PAY_NO {
            
            return kDRIVER_PAY_NO
        } else {
            
            return (biz.order?.DRIVER_PAY)!
        }
    }
    
    
    // 未知订单交付状态 提示
    func unknownPrompt() {
        
        Tools.showAlertDialog("未知的订单交付状态\(self.DRIVER_PAY())", self)
    }
    
    
    func setButtonTitle() {
        
        if self.DRIVER_PAY() == kDRIVER_PAY_YES {
            
            navigationOrCheckPathBtn.setTitle("查看路线", for: .normal)
            deliverOrCheckPictureBtn.setTitle("查看图片", for: .normal)
        } else if self.DRIVER_PAY() == kDRIVER_PAY_NO {
            
            navigationOrCheckPathBtn.setTitle("实时导航", for: .normal)
            deliverOrCheckPictureBtn.setTitle("交付", for: .normal)
        } else {
            
            Tools.showAlertDialog("未知的订单交付状态\(self.DRIVER_PAY())", self)
        }
    }
    
    
    // MARK: - 事件
    
    @IBAction func navigationOrCheckPathOnclick(_ sender: UIButton) {
        
        if self.DRIVER_PAY() == kDRIVER_PAY_YES {
            
            // 查看路线
            let checkPathController = CheckPathViewController(nibName:"CheckPathViewController", bundle: nil)
            checkPathController.orderIDX = (biz.order?.IDX)!
            checkPathController.driver_pay = 1;
            self.navigationController?.pushViewController(checkPathController, animated: true)
        } else if self.DRIVER_PAY() == kDRIVER_PAY_NO {
            
            // 实时导航
            maps.removeAll()
            maps.append("苹果自带地图")
            
            if(UIApplication.shared.canOpenURL(URL(string: "iosamap://")!)) {
                maps.append("高德地图")
            }
            if(UIApplication.shared.canOpenURL(URL(string: "baidumap://")!)) {
                maps.append("百度地图")
            }
            if(UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
                maps.append("谷歌地图")
            }
            mapsSheet(maps)
        } else {
            
            Tools.showAlertDialog("未知的订单交付状态\(self.DRIVER_PAY())", self)
        }
    }
    
    
    @IBAction func deliverOrCheckPictureOnclick(_ sender: UIButton) {
        
        if self.DRIVER_PAY() == kDRIVER_PAY_YES {
            
            // 查看签名、图片
            self.title = ""
            let checkAutographAndPictureController = CheckAutographAndPictureViewController(nibName: "CheckAutographAndPictureViewController", bundle: nil)
            checkAutographAndPictureController.orderIDX = (biz.order?.IDX)!
            self.navigationController?.pushViewController(checkAutographAndPictureController, animated: true)
        } else if self.DRIVER_PAY() == kDRIVER_PAY_NO {
            
            // 交付订单
            self.title = ""
            let payOrderController = PayOrderViewController(nibName:"PayOrderViewController", bundle: nil)
            payOrderController.orderIDX = (biz.order?.IDX)!
            print(biz.order)
            self.navigationController?.pushViewController(payOrderController, animated: true)
        } else {
            
            Tools.showAlertDialog("未知的订单交付状态\(self.DRIVER_PAY())", self)
        }
    }
    
    
    // 查看计费
    @IBAction func checkBillingOnclick(_ sender: UIButton) {
        if DRIVER_PAY() == "已交付" {
            
            let auditStatus : ShipmentAuditStatus = (biz.order?.ShipmentAuditStatusStatus)!
            
            if auditStatus.AUDIT_FLAG == "Y" {
                
                let vc = BillingViewController(nibName: "BillingViewController", bundle: nil)
                vc.shipmentNO = biz.order?.TMS_SHIPMENT_NO
                vc.orderNO = biz.order?.ORD_NO
                self.navigationController?.pushViewController(vc, animated: true)
            } else if auditStatus.ERROR_FLAG == "Y" {
                
                Tools.showAlertDialog(auditStatus.ERROR_DESC, self)
            } else {
                
                Tools.showAlertDialog(kCheckBillingStatus_NO, self)
            }
        } else if DRIVER_PAY() == "未交付" {
            
            let driverListPayViewController = DriverListPayViewController(nibName:"DriverListPayViewController", bundle: nil)
            driverListPayViewController.TMS_SHIPMENT_NO = (biz.order?.TMS_SHIPMENT_NO)!
            self.navigationController?.pushViewController(driverListPayViewController, animated: true)
        }
    }
    
    
    // MARK: - HttpResponseProtocol
    /// 获取订单详情成功返回数据
    func responseSuccess() {
        
        print("=========responseSuccess1")
        //如果已经Pop，就不要执行getGeoCod函数，否则会carsh
        if(isPopVC) {
            //通过地址转成坐标
            return
        }
        
        dismissLoading()
        
        print("=========responseSuccess2")
        if let orderDetail = biz.order {
            orderNumber.text = orderDetail.ORD_NO
            ORD_NO_CLIENT.text = orderDetail.ORD_NO_CLIENT
            orderShipmentNumber.text = orderDetail.TMS_SHIPMENT_NO
            orderLoadDate.text = orderDetail.TMS_DATE_LOAD
            orderIssueDate.text = orderDetail.TMS_DATE_ISSUE
            orderFleetName.text = orderDetail.TMS_FLEET_NAME
            orderPlateNumber.text = orderDetail.TMS_PLATE_NUMBER
            orderDriverName.text = orderDetail.TMS_DRIVER_NAME
            orderDriverTelephone.text = orderDetail.TMS_DRIVER_TEL
            orderState.text = StringUtils.getOrderStatus(orderDetail.ORD_STATE)
            orderWorkFlow.text = StringUtils.getOrderState(orderDetail.ORD_WORKFLOW)
            orderPayState.text = orderDetail.DRIVER_PAY
            orderIssueQty.text = Tools.twoDecimal(text: orderDetail.ORD_ISSUE_QTY) + "件"
            orderIssueWeight.text = Tools.twoDecimal(text: orderDetail.ORD_ISSUE_WEIGHT) + "吨"
            orderIssueVolume.text = Tools.twoDecimal(text: orderDetail.ORD_ISSUE_VOLUME) + "方"
            orderToName.text = orderDetail.ORD_TO_NAME
            orderFromeName.text = orderDetail.ORD_FROM_NAME
            orderToAddress.text = orderDetail.ORD_TO_ADDRESS
            
            self.setButtonTitle()
            
            orderDetailsTableView.reloadData()
            
            
            if DRIVER_PAY() == "已交付" {
                
                oneBtn_width.constant = (SCREEN_WIDTH - 40) / 2
                twoBtn_width.constant = (SCREEN_WIDTH - 40) / 2
                threeBtn_width.constant = 0
                twoThree_width.constant = 0
            } else if DRIVER_PAY() == "未交付" {
                
                oneBtn_width.constant = (SCREEN_WIDTH - 40) / 3
                twoBtn_width.constant = (SCREEN_WIDTH - 40) / 3
                threeBtn_width.constant = (SCREEN_WIDTH - 40) / 3
                checkBillingBtn.setTitle("批量交付", for: .normal)
                
                //通过地址转成坐标
                getGeoCode()
            }
        }
        print("=========responseSuccess3")
    }
    
    /**
     * 获取订单详情信息失败回调方法
     *
     * message: 显示的信息
     */
    func responseError(_ error: String) {
        Tools.showAlertDialog(error, self)
        dismissLoading()
    }
    
    // MARK: - UITableViewDelegate
    /// 设置 tableview 数据数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        if let order = biz.order {
            let details = order.OrderDetails
            count = details.count
        }
        return count
    }
    
    /// 设置 cell 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    /// 设置自定义的 cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OrderDetailsTableViewCell
        cell.orderDetail = biz.order?.OrderDetails[(indexPath as NSIndexPath).row]
        return cell
    }
}
