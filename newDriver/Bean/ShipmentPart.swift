//
//  ShipmentPart.swift
//  newDriver
//
//  Created by 凯东源 on 17/3/23.
//  Copyright © 2017年 凯东源. All rights reserved.
//


import Foundation
import ObjectMapper


class ShipmentPart: BaseBean {
    
    
    /// 装运编号
    var SHIPMENT_NO: String = ""
    
    /// 调整金额
    var ADJUST_FEES: String = ""
    
    /// 调整类型
    var ADJUST_CLASS: String = ""
    
    /// 出库时间
    var DATE_ISSUE: String = ""
    
    /// 司机
    var DRIVER_NAME: String = ""
    
    /// 司机号码
    var DRIVER_TEL: String = ""
    
    /// 车牌号
    var PLATE_NUMBER: String = ""
    
    /// 承运商名
    var TMS_FLEET_NAME: String = ""
    
    /// 审核备注
    var AUDIT_REMARK: String = ""
    
    /// 装运时间
    var DATE_ADD: String = ""
    
    /// 总量
    var TOTAL_QTY: String = ""
    
    /// 重量
    var TOTAL_WEIGHT: String = ""
    
    /// 体积
    var TOTAL_VOLUME: String = ""
    
    /// 是否计费
    var AUDIT_FLAG: String = ""
    
    /// 是否错误
    var ERROR_FLAG: String = ""
    
    /// 提示
    var ERROR_DESC: String = ""
    
    /// 计费量
    var CHARGE_AMOUNT: String = ""
    
    /// 运输费
    var TRANSPORT_FEES: String = ""
    
    /// 分点费
    var DROPPOINT_FEES: String = ""
    
    /// 燃油附加费费
    var FUEL_SURCHARGE: String = ""
    
    /// 收货人附加费
    var SITE_SURCHARGE: String = ""
    
    /// 退货费
    var RETURN_FEES: String = ""
    
    /// 提送货费
    var DELIVER_FEES: String = ""
    
    /// 压夜费
    var PRESS_NIGHT: String = ""
    
    /// 装卸费
    var LOAD_FEES: String = ""
    
    /// 其他费
    var OTHER_FEES: String = ""
    
    /// 计费单价
    var AMOUNT_PRICE: String = ""
    
    /// 总费用
    var FEESCOUNT: String = ""
    
    
    override func mapping(map: Map) {
        
        SHIPMENT_NO <- map["SHIPMENT_NO"]
        ADJUST_FEES <- map["ADJUST_FEES"]
        ADJUST_CLASS <- map["ADJUST_CLASS"]
        DATE_ISSUE <- map["DATE_ISSUE"]
        DRIVER_NAME <- map["DRIVER_NAME"]
        DRIVER_TEL <- map["DRIVER_TEL"]
        PLATE_NUMBER <- map["PLATE_NUMBER"]
        TMS_FLEET_NAME <- map["TMS_FLEET_NAME"]
        AUDIT_REMARK <- map["AUDIT_REMARK"]
        DATE_ADD <- map["DATE_ADD"]
        TOTAL_QTY <- map["TOTAL_QTY"]
        TOTAL_WEIGHT <- map["TOTAL_WEIGHT"]
        TOTAL_VOLUME <- map["TOTAL_VOLUME"]
        AUDIT_FLAG <- map["AUDIT_FLAG"]
        ERROR_FLAG <- map["ERROR_FLAG"]
        ERROR_DESC <- map["ERROR_DESC"]
        CHARGE_AMOUNT <- map["CHARGE_AMOUNT"]
        TRANSPORT_FEES <- map["TRANSPORT_FEES"]
        DROPPOINT_FEES <- map["DROPPOINT_FEES"]
        FUEL_SURCHARGE <- map["FUEL_SURCHARGE"]
        SITE_SURCHARGE <- map["SITE_SURCHARGE"]
        RETURN_FEES <- map["RETURN_FEES"]
        DELIVER_FEES <- map["DELIVER_FEES"]
        PRESS_NIGHT <- map["PRESS_NIGHT"]
        LOAD_FEES <- map["LOAD_FEES"]
        OTHER_FEES <- map["OTHER_FEES"]
        AMOUNT_PRICE <- map["AMOUNT_PRICE"]
        FEESCOUNT <- map["FEESCOUNT"]
    }
}
