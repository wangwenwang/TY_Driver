//
//  BillingViewController.swift
//  newDriver
//
//  Created by 凯东源 on 17/3/22.
//  Copyright © 2017年 凯东源. All rights reserved.
//

import UIKit
import MapKit



class BillingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HttpResponseProtocol {
    
    
    
    var shipmentNO : String! = ""
    var orderNO : String! = ""
    
    
    
    
    
    
    
    
    
    /// 此订单信息 高度
    @IBOutlet weak var thisOrderInfoViewHeight: NSLayoutConstraint!
    
    /// 订单号(订单)
    @IBOutlet weak var kORD_NO: UILabel!
    
    /// 客户订单号(订单)
    @IBOutlet weak var kORD_NO_CLIENT: UILabel!
    
    /// 起运名称(订单)
    @IBOutlet weak var kORD_FROM_NAMES: UILabel!
    
    /// 到达名称(订单)
    @IBOutlet weak var kORD_TO_NAME: UILabel!
    
    /// 计费量(订单)
    @IBOutlet weak var kCHARGE_AMOUNT: UILabel!
    
    /// 运输费(订单)
    @IBOutlet weak var kTRANSPORT_FEES: UILabel!
    
    /// 分点费(订单)
    @IBOutlet weak var kDROPPOINT_FEES: UILabel!
    
    /// 退货费(订单)
    @IBOutlet weak var kRETURN_FEES: UILabel!
    
    /// 压夜费(订单)
    @IBOutlet weak var kPRESS_NIGHT: UILabel!
    
    /// 装卸费(订单)
    @IBOutlet weak var kLOAD_FEES: UILabel!
    
    /// 其他费(订单)
    @IBOutlet weak var kOTHER_FEES: UILabel!
    
    /// 总量(订单)
    @IBOutlet weak var kORD_QTY: UILabel!
    
    /// 重量(订单)
    @IBOutlet weak var kORD_WEIGHT: UILabel!
    
    /// 体积(订单)
    @IBOutlet weak var kORD_VOLUME: UILabel!
    
    /// 提送货费(订单)
    @IBOutlet weak var kDELIVER_FEES: UILabel!
    
    /// 计费单价(订单)
    @IBOutlet weak var kAMOUNT_PRICE: UILabel!
    
    /// 燃油附加费(订单)
    @IBOutlet weak var kFUEL_SURCHARGE: UILabel!
    
    /// 收货人附加费(订单)
    @IBOutlet weak var kSITE_SURCHARGE: UILabel!
    
    /// 总费用
    @IBOutlet weak internal var kFEESCOUNT: UILabel!
    
    
    
    
    
    
    
    
    
    
    
    // 下展View
    @IBOutlet weak var downShowView: UIView!
    
    // 下展View 高度
    @IBOutlet weak var downShowViewHeight: NSLayoutConstraint!
    
    // 下展View 按钮
    @IBOutlet weak var showShipmentInfoBtn: UIButton!
    
    // 下展提示 Label
    @IBOutlet weak var showShipmentInfoPromptLabel: UILabel!
    
    // 下展提示 Label 右偏移
    @IBOutlet weak var showShipmentInfoPromptLabelCenterX: NSLayoutConstraint!
    
    // 订单费用 TableView
    @IBOutlet weak var orderBillingTableView: UITableView!
    
    // 其它费用 TableView
    @IBOutlet weak var otherBillingTableView: UITableView!
    
    @IBOutlet weak var noOtherBillingView: UIView!
    // 订单费用 TableView 高度
    @IBOutlet weak var orderBillingTableViewHeight: NSLayoutConstraint!
    
    // 其它费用 TableView 高度
    @IBOutlet weak var otherBillingTableViewHeight: NSLayoutConstraint!
    
    // scrollContentView高度
    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!
    
    // 提示View 高度
    @IBOutlet weak var promptViewHeight: NSLayoutConstraint!
    
    // 装运信息View 高度
    @IBOutlet weak var shipmentInfoViewHeight: NSLayoutConstraint!
    
    // 装运费用View 高度
    @IBOutlet weak var shipmentBillingViewHeight: NSLayoutConstraint!
    
    
    // 装运编号
    @IBOutlet weak var SHIPMENT_NO: UILabel!
    
    // 装运时间
    @IBOutlet weak var DATE_ADD: UILabel!
    
    // 出库时间
    @IBOutlet weak var DATE_ISSUE: UILabel!
    
    // 承运商名
    @IBOutlet weak var TMS_FLEET_NAME: UILabel!
    
    // 车牌号
    @IBOutlet weak var PLATE_NUMBER: UILabel!
    
    // 司机号码
    @IBOutlet weak var DRIVER_TEL: UILabel!
    
    // 司机
    @IBOutlet weak var DRIVER_NAME: UILabel!
    
    // 装运总量
    @IBOutlet weak var TOTAL_QTY: UILabel!
    
    // 装运重量
    @IBOutlet weak var TOTAL_WEIGHT: UILabel!
    
    // 装运体积
    @IBOutlet weak var TOTAL_VOLUME: UILabel!
    
    // 是否计费
    @IBOutlet weak var AUDIT_FLAG: UILabel!
    
    // 计费错误提示
    @IBOutlet weak var ERROR_DESC: UILabel!
    
    // 计费量
    @IBOutlet weak var CHARGE_AMOUNT: UILabel!
    
    // 运输费
    @IBOutlet weak var TRANSPORT_FEES: UILabel!
    
    // 分点费
    @IBOutlet weak var DROPPOINT_FEES: UILabel!
    
    // 退货费
    @IBOutlet weak var RETURN_FEES: UILabel!
    
    // 压夜费
    @IBOutlet weak var PRESS_NIGHT: UILabel!
    
    // 收货人附加费
    @IBOutlet weak var SITE_SURCHARGE: UILabel!
    
    // 装卸费
    @IBOutlet weak var LOAD_FEES: UILabel!
    
    // 其他费
    @IBOutlet weak var OTHER_FEES: UILabel!
    
    // 提送货费
    @IBOutlet weak var DELIVER_FEES: UILabel!
    
    // 计费单价
    @IBOutlet weak var AMOUNT_PRICE: UILabel!
    
    // 调整类型
    @IBOutlet weak var ADJUST_CLASS: UILabel!
    
    // 调整金额
    @IBOutlet weak var ADJUST_FEES: UILabel!
    
    // 燃油附加费费
    @IBOutlet weak var FUEL_SURCHARGE: UILabel!
    
    // 审核备注
    @IBOutlet weak var AUDIT_REMARK: UILabel!
    
    // 总费用
    @IBOutlet weak var FEESCOUNT: UILabel!
    
    // 审核备注 top
    @IBOutlet weak var AUDIT_REMARK_top: NSLayoutConstraint!
    
    fileprivate let biz: ShipmentAuditStatusBiz = ShipmentAuditStatusBiz()
    
    /// 排序好的订单信息列表
    var shipment_OrderList_Temp : NSMutableArray! = nil
    
    
    let OrderBillingTableViewCell = "OrderBillingTableViewCell"
    let OtherBillingTableViewCell = "OtherBillingTableViewCell"
    
    let OrderBillingTableViewCellHeight : CGFloat = 233
    let OtherBillingTableViewCellHeight : CGFloat = 69.0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "费用信息"
        self.orderBillingTableView.register(UINib.init(nibName: "OrderBillingTableViewCell", bundle: nil), forCellReuseIdentifier: OrderBillingTableViewCell)
        self.otherBillingTableView.register(UINib.init(nibName: "OtherBillingTableViewCell", bundle: nil), forCellReuseIdentifier: OtherBillingTableViewCell)
        
        
        if let idx = shipmentNO {
            //判断连接状态
            let reachability = Reachability.forInternetConnection()
            
            if reachability!.isReachable() {
                
                //                #if DEBUG
                //                    let temp = Int(arc4random()%2)+1
                //                    if temp == 1 {
                //
                //                        shipmentNO = "0000019107"  // 有订单计费
                //                    }
                //                    else if temp == 2 {
                //
                //                        shipmentNO = "0000009392"  // 有订单计费和其它计费
                //                    }
                //                #else
                //
                //                #endif
                
                
                _ = MBProgressHUD .showHUDAddedTo(self.view, animated: true)
                biz.getShipmentData(shipmentNO: shipmentNO, httpresponseProtocol: self)
            }else{
                
                self.responseError("网络连接不可用!")
            }
        }
        
        //        downShowViewHeight.constant = 0
        
        // 初始化
        downShowView.isHidden = true
        showShipmentInfoBtn.setImage(UIImage.init(named: "dwonShow"), for: .normal)
        showShipmentInfoBtn.setImage(UIImage.init(named: "recyclingView"), for: .selected)
        showShipmentInfoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 107)

        
        //        shipmentInfoViewHeight.constant = 0
        //        shipmentBillingViewHeight.constant = 0
        //        orderBillingTableViewHeight.constant = 0
        //        otherBillingTableViewHeight.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - 功能函数
    /**
     计算label的宽度和高度
     
     :param: text       label的text的值
     :param: font label设置的字体
     
     :returns: 返回计算后label的高度
     */
    func getHeightByWidth(text:String, width:CGFloat, font:UIFont) -> CGFloat {
        
        let label : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        label.text = text
        label.font = font
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label.frame.size.height
    }
    
    
    // MARK: - 事件
    
    // 展开整车装运信息
    
    @IBAction func showShipmentInfoOnclick(_ sender: UIButton) {
        
        let m : ShipmentPart = (biz.shipmentInfo?.ShipmentPart)!
        
        // 当计费单价多行时
        let AUDIT_REMARK_LabelHeight : CGFloat = getHeightByWidth(text: m.AMOUNT_PRICE, width: SCREEN_WIDTH - 8 - 53, font: UIFont.systemFont(ofSize: 12.0))
        AUDIT_REMARK_top.constant = AUDIT_REMARK_LabelHeight - 14.5
        
        // 如果没有其它计费，scrollContentView高度增加30，用于提示
        var otherBillingHeight : CGFloat = 0
        if biz.shipmentInfo?.Shipment_OtherCostList.count == 0 {
            
            otherBillingHeight = 30
            noOtherBillingView.isHidden = false
        } else {
            
            noOtherBillingView.isHidden = true
        }
        
        // 计费单价多行
        //        shipmentBillingViewHeight.constant = shipmentBillingViewHeight.constant + AUDIT_REMARK_top.constant
        
        orderBillingTableViewHeight.constant = OrderBillingTableViewCellHeight * CGFloat((biz.shipmentInfo?.Shipment_OrderList.count)!)
        otherBillingTableViewHeight.constant = OtherBillingTableViewCellHeight * CGFloat((biz.shipmentInfo?.Shipment_OtherCostList.count)!)
        
        
        //        downShowViewHeight.constant = 700
        
        if !showShipmentInfoBtn.isSelected {
            
            downShowView.isHidden = false
            showShipmentInfoBtn.isSelected = true
//            showShipmentInfoPromptLabel.isHidden = true
            showShipmentInfoPromptLabel.text = "整车装运信息"
            
            // 4个提示 + 此订单信息 + 整车装运信息 + 整车装运计费 + 整车订单计费Table + 整车其它计费Table + 其它计费提示(例如：无) + 计费单价多行
            scrollContentViewHeight.constant = promptViewHeight.constant * 5 + thisOrderInfoViewHeight.constant + orderBillingTableViewHeight.constant + shipmentInfoViewHeight.constant + shipmentBillingViewHeight.constant + otherBillingTableViewHeight.constant + otherBillingHeight + AUDIT_REMARK_top.constant
        } else {
            
            downShowView.isHidden = true
            showShipmentInfoBtn.isSelected = false
            //            showShipmentInfoPromptLabel.isHidden = false
            showShipmentInfoPromptLabel.text = "(点击查看装运信息)"
            
            // 4个提示 + 此订单信息
            scrollContentViewHeight.constant = promptViewHeight.constant * 2 + thisOrderInfoViewHeight.constant
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(tableView.tag == 1001) {
            
            return (biz.shipmentInfo != nil) ? biz.shipmentInfo!.Shipment_OrderList.count : 0
        } else if(tableView.tag == 1002) {
            
            return (biz.shipmentInfo != nil) ? biz.shipmentInfo!.Shipment_OtherCostList.count : 0
        }
        
        return 0
    }
    
    
    /// 设置 cell 高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(tableView.tag == 1001) {
            
            return OrderBillingTableViewCellHeight
        } else if(tableView.tag == 1002) {
            
            return OtherBillingTableViewCellHeight
        }
        
        return 0
    }
    
    /// 设置自定义的 cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView.tag == 1001) {
            
            let cell : OrderBillingTableViewCell = tableView.dequeueReusableCell(withIdentifier: OrderBillingTableViewCell, for: indexPath) as! OrderBillingTableViewCell
            
            let m : Shipment_OrderList = shipment_OrderList_Temp[indexPath.row] as! Shipment_OrderList
            
            cell.orderListM = m
            
            return cell
        } else if(tableView.tag == 1002) {
            
            let cell : OtherBillingTableViewCell = tableView.dequeueReusableCell(withIdentifier: OtherBillingTableViewCell, for: indexPath) as! OtherBillingTableViewCell
            
            let m : Shipment_OtherCostList = biz.shipmentInfo!.Shipment_OtherCostList[indexPath.row]
            
            cell.otherBilling = m
            
            return cell
        } else {
            
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            
            return cell
        }
    }
    
    
    // MARK: - HttpResponseProtocol
    
    func responseSuccess() {
        
        _ = MBProgressHUD.hideHUDForView(self.view, animated: true)
        
        
        // 对订单信息列表进行排序，点进来的订单排在第一个
        
        /// 排序好的订单信息列表
        shipment_OrderList_Temp = NSMutableArray()
        
        var thisOrderM : Shipment_OrderList! = nil
        
        for shipment_OrderList : Shipment_OrderList in biz.shipmentInfo!.Shipment_OrderList {
            
            if shipment_OrderList.ORD_NO == orderNO {
                
                thisOrderM = shipment_OrderList
            } else {
                
                
                shipment_OrderList_Temp.add(shipment_OrderList)
            }
        }
        
        shipment_OrderList_Temp.insert(thisOrderM, at: 0)
        
        
        
        
        // 此订单信息
        if thisOrderM != nil {
            
            kORD_NO.text = thisOrderM.ORD_NO
            kORD_NO_CLIENT.text = thisOrderM.ORD_NO_CLIENT
            kORD_FROM_NAMES.text = thisOrderM.ORD_FROM_NAME
            kORD_TO_NAME.text = thisOrderM.ORD_TO_NAME
            kCHARGE_AMOUNT.text = Tools.twoDecimal(text: thisOrderM.CHARGE_AMOUNT)
            kTRANSPORT_FEES.text = Tools.twoDecimal(text: thisOrderM.TRANSPORT_FEES)
            kDROPPOINT_FEES.text = Tools.twoDecimal(text: thisOrderM.DROPPOINT_FEES)
            kRETURN_FEES.text = Tools.twoDecimal(text: thisOrderM.RETURN_FEES)
            kPRESS_NIGHT.text = Tools.twoDecimal(text: thisOrderM.PRESS_NIGHT)
            kLOAD_FEES.text = Tools.twoDecimal(text: thisOrderM.LOAD_FEES)
            kOTHER_FEES.text = Tools.twoDecimal(text: thisOrderM.OTHER_FEES)
            kORD_QTY.text = Tools.twoDecimal(text: thisOrderM.ORD_QTY) + "件"
            kORD_WEIGHT.text = Tools.twoDecimal(text: thisOrderM.ORD_WEIGHT) + "吨"
            kORD_VOLUME.text = Tools.twoDecimal(text: thisOrderM.ORD_VOLUME) + "方"
            kDELIVER_FEES.text = Tools.twoDecimal(text: thisOrderM.DELIVER_FEES)
            kAMOUNT_PRICE.text = thisOrderM.AMOUNT_PRICE
            kFUEL_SURCHARGE.text = Tools.twoDecimal(text: thisOrderM.FUEL_SURCHARGE)
            kSITE_SURCHARGE.text = Tools.twoDecimal(text: thisOrderM.SITE_SURCHARGE)
            kFEESCOUNT.text = Tools.twoDecimal(text: thisOrderM.FEESCOUNT)
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        // 整车装运信息
        if biz.shipmentInfo?.ShipmentPart == nil {
            
            Tools .showAlertDialog("装运模块异常", self)
            return
        }
        let m : ShipmentPart = (biz.shipmentInfo?.ShipmentPart)!
        
        
        SHIPMENT_NO.text = m.SHIPMENT_NO
        DATE_ADD.text = m.DATE_ADD
        DATE_ISSUE.text = m.DATE_ISSUE
        TMS_FLEET_NAME.text = m.TMS_FLEET_NAME
        PLATE_NUMBER.text = m.PLATE_NUMBER
        DRIVER_TEL.text = m.DRIVER_TEL
        DRIVER_NAME.text = m.DRIVER_NAME
        TOTAL_QTY.text = "\(Tools.twoDecimal(text: m.TOTAL_QTY))件"
        TOTAL_WEIGHT.text = "\(Tools.twoDecimal(text: m.TOTAL_WEIGHT))吨"
        TOTAL_VOLUME.text = "\(Tools.twoDecimal(text: m.TOTAL_VOLUME))方"
        //        AUDIT_FLAG.text = m.AUDIT_FLAG
        //        ERROR_DESC.text = m.ERROR_DESC
        CHARGE_AMOUNT.text = Tools.twoDecimal(text: m.CHARGE_AMOUNT)
        TRANSPORT_FEES.text = Tools.twoDecimal(text: m.TRANSPORT_FEES)
        DROPPOINT_FEES.text = Tools.twoDecimal(text: m.DROPPOINT_FEES)
        RETURN_FEES.text = Tools.twoDecimal(text: m.RETURN_FEES)
        PRESS_NIGHT.text = Tools.twoDecimal(text: m.PRESS_NIGHT)
        SITE_SURCHARGE.text = Tools.twoDecimal(text: m.SITE_SURCHARGE)
        LOAD_FEES.text = Tools.twoDecimal(text: m.LOAD_FEES)
        OTHER_FEES.text = Tools.twoDecimal(text: m.OTHER_FEES)
        DELIVER_FEES.text = Tools.twoDecimal(text: m.DELIVER_FEES)
        AMOUNT_PRICE.text = m.AMOUNT_PRICE
        FUEL_SURCHARGE.text = Tools.twoDecimal(text: m.FUEL_SURCHARGE)
        ADJUST_FEES.text = Tools.twoDecimal(text: m.ADJUST_FEES)
        ADJUST_CLASS.text = m.ADJUST_CLASS
        AUDIT_REMARK.text = m.AUDIT_REMARK
        FEESCOUNT.text = Tools.twoDecimal(text: m.FEESCOUNT)
        
        // 当计费单价多行时
        let AUDIT_REMARK_LabelHeight : CGFloat = getHeightByWidth(text: m.AMOUNT_PRICE, width: SCREEN_WIDTH - 8 - 53, font: UIFont.systemFont(ofSize: 12.0))
        AUDIT_REMARK_top.constant = AUDIT_REMARK_LabelHeight - 14.5
        
        // 如果没有其它计费，scrollContentView高度增加30，用于提示
        var otherBillingHeight : CGFloat = 0
        if biz.shipmentInfo?.Shipment_OtherCostList.count == 0 {
            
            otherBillingHeight = 30
            noOtherBillingView.isHidden = false
        } else {
            
            noOtherBillingView.isHidden = true
        }
        
        // 计费单价多行
        shipmentBillingViewHeight.constant = shipmentBillingViewHeight.constant + AUDIT_REMARK_top.constant
        
        orderBillingTableViewHeight.constant = OrderBillingTableViewCellHeight * CGFloat((biz.shipmentInfo?.Shipment_OrderList.count)!)
        otherBillingTableViewHeight.constant = OtherBillingTableViewCellHeight * CGFloat((biz.shipmentInfo?.Shipment_OtherCostList.count)!)
        
        // 4个提示 + 此订单信息
        scrollContentViewHeight.constant = promptViewHeight.constant * 2 + thisOrderInfoViewHeight.constant
        
        orderBillingTableView.reloadData()
        otherBillingTableView.reloadData()
    }
    
    
    func responseError(_ error: String) {
        
        _ = MBProgressHUD.hideHUDForView(self.view, animated: true)
        Tools.showAlertDialog(error, self)
    }
}
