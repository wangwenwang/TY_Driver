//
//  Order.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/27.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import ObjectMapper


/// 订单信息
class Order: BaseBean {
    
    /// 订单装运时间
    var TMS_DATE_LOAD: String = ""
    /// 订单出库时间
    var TMS_DATE_ISSUE: String = ""
    /// 订单装运编号
    var TMS_SHIPMENT_NO: String = ""
    ///
    var TMS_FLEET_NAME: String = ""
    ///
    var ORD_IDX: String = ""
    
    /// 订单 id
    var IDX: String = ""
    /// 订单编号
    var ORD_NO: String = ""
    /// 客户订单编号
    var ORD_NO_CLIENT: String = ""
    /// 客户名称
    var ORD_TO_NAME: String = ""
    /// 客户类型
    var PARTY_TYPE: String = ""
    /// 收货人
    var ORD_TO_CNAME: String = ""
    /// 目的地址
    var ORD_TO_ADDRESS: String = ""
    
    /// 订单总数量
    var ORD_QTY: String = ""
    /// 订单总重量
    var ORD_WEIGHT: String = ""
    /// 订单总体积
    var ORD_VOLUME: String = ""
    ///
    var ORD_ISSUE_QTY: String = ""
    ///
    var ORD_ISSUE_WEIGHT: String = ""
    ///
    var ORD_ISSUE_VOLUME: String = ""
    
    /// 订单流程
    var ORD_WORKFLOW: String = ""
    ///
    var OMS_SPLIT_TYPE: String = ""
    ///
    var OMS_PARENT_NO: String = ""
    /// 订单状态
    var ORD_STATE: String = ""
    /// 创建时间
    var ORD_DATE_ADD: String = ""
    /// 下单用户
    var ADD_CODE: String = ""
    
    ///
    var ORD_REQUEST_ISSUE: String = ""
    ///
    var ORD_FROM_NAME: String = ""
    /// 起始点坐标
    var FROM_COORDINATE: String = ""
    /// 到达点坐标
    var TO_COORDINATE: String = ""
    ///
    var ORD_REMARK_CLIENT: String = ""
    /// 司机姓名
    var TMS_DRIVER_NAME: String = ""
    
    /// 车牌号
    var TMS_PLATE_NUMBER: String = ""
    /// 司机电话
    var TMS_DRIVER_TEL: String = ""
    ///
    var PAYMENT_TYPE: String = ""
    ///
    var ORG_PRICE: Double = 0.0
    ///
    var ACT_PRICE: Double = 0.0
    ///
    var MJ_PRICE: Double = 0.0
    
    ///
    var ORD_REMARK_CONSIGNEE: String = ""
    ///
    var MJ_REMARK: String = ""
    ///司机交付标志， yb司机交付状态
    var DRIVER_PAY: String = ""
    ///
    var OrderDetails: [OrderDetail] = []
    ///
    var StateTacks: [StateTack] = []
    ///
    var ShipmentAuditStatusStatus: ShipmentAuditStatus?
    
    /// 是否计费
    var AUDIT_FLAG: String = ""
    /// 是否错误ORD_ISSUE_WEIGHT
    var ERROR_FLAG: String = ""
    
    /// Cell高度
    var cellHeight: CGFloat = 0
    
    /// 点击状态
    var cellSelected: Bool = false
    
    
    override func mapping(map: Map) {
        TMS_DATE_LOAD <- map["TMS_DATE_LOAD"]
        TMS_DATE_ISSUE <- map["TMS_DATE_ISSUE"]
        TMS_SHIPMENT_NO <- map["TMS_SHIPMENT_NO"]
        TMS_FLEET_NAME <- map["TMS_FLEET_NAME"]
        ORD_IDX <- map["ORD_IDX"]
        
        IDX <- map["IDX"]
        ORD_NO <- map["ORD_NO"]
        ORD_NO_CLIENT <- map["ORD_NO_CLIENT"]
        ORD_TO_NAME <- map["ORD_TO_NAME"]
        PARTY_TYPE <- map["PARTY_TYPE"]
        ORD_TO_CNAME <- map["ORD_TO_CNAME"]
        ORD_TO_ADDRESS <- map["ORD_TO_ADDRESS"]
        
        ORD_QTY <- map["ORD_QTY"]
        ORD_WEIGHT <- map["ORD_WEIGHT"]
        ORD_VOLUME <- map["ORD_VOLUME"]
        ORD_ISSUE_QTY <- map["ORD_ISSUE_QTY"]
        ORD_ISSUE_WEIGHT <- map["ORD_ISSUE_WEIGHT"]
        ORD_ISSUE_VOLUME <- map["ORD_ISSUE_VOLUME"]
        
        ORD_WORKFLOW <- map["ORD_WORKFLOW"]
        OMS_SPLIT_TYPE <- map["OMS_SPLIT_TYPE"]
        OMS_PARENT_NO <- map["OMS_PARENT_NO"]
        ORD_STATE <- map["ORD_STATE"]
        ORD_DATE_ADD <- map["ORD_DATE_ADD"]
        ADD_CODE <- map["ADD_CODE"]
        
        ORD_REQUEST_ISSUE <- map["ORD_REQUEST_ISSUE"]
        ORD_FROM_NAME <- map["ORD_FROM_NAME"]
        FROM_COORDINATE <- map["FROM_COORDINATE"]
        TO_COORDINATE <- map["TO_COORDINATE"]
        ORD_REMARK_CLIENT <- map["ORD_REMARK_CLIENT"]
        TMS_DRIVER_NAME <- map["TMS_DRIVER_NAME"]
        
        TMS_PLATE_NUMBER <- map["TMS_PLATE_NUMBER"]
        TMS_DRIVER_TEL <- map["TMS_DRIVER_TEL"]
        PAYMENT_TYPE <- map["PAYMENT_TYPE"]
        ORG_PRICE <- map["ORG_PRICE"]
        ACT_PRICE <- map["ACT_PRICE"]
        MJ_PRICE <- map["MJ_PRICE"]
        
        ORD_REMARK_CONSIGNEE <- map["ORD_REMARK_CONSIGNEE"]
        MJ_REMARK <- map["MJ_REMARK"]
        DRIVER_PAY <- map["DRIVER_PAY"]
        OrderDetails <- map["OrderDetails"]
        StateTacks <- map["StateTack"]
        ShipmentAuditStatusStatus <- map["Shipment"]
        
        AUDIT_FLAG <- map["AUDIT_FLAG"]
        ERROR_FLAG <- map["ERROR_FLAG"]
    }
}





















