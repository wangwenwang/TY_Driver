//
//  LoginBiz.swift
//  kdyDriver
//
//  Created by 凯东源 on 16/6/24.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class LoginBiz {
    
    /// 上传位置点时间间隔，默认为5分钟，后台返回的type动态更改上传时间间隔
    var updataLocationSpanTimeMin: Double = 0.1
    
    /// 是否需要更改上传时间间隔
    var isNeedChangeUpdataLocationSpanTime: Bool = false
    
    /// 上传缓存位置点信息集合是每次上传的数量
    fileprivate let updataCacheLocationsCount: Int = 20
    
    
    /**
     * 登陆
     *
     * userName: 用户名
     *
     * password: 用户登陆密码
     *
     * httpresponseProtocol: 网络请求协议
     */
    func login (userName name: String, password pwd:String, httpresponseProtocol responseProtocol: HttpResponseProtocol) {
        let parameters = [
            "strUserName": name,
            "strPassword": pwd,
            "strLicense": ""
        ]
        
        weak var weakSelf = self
        
        NetWorkBaseBiz().postWithPath(path: URLConstants.loginUrl, paras: parameters, success: {(result) in
            DispatchQueue.main.async {
                print(result)
                
                var dictReturn :NSDictionary? = nil
                dictReturn = result as? NSDictionary
                
                if let wkSelf = weakSelf {
                    if dictReturn != nil {
                        let json = JSON(result)
                        print("JSON: \(json)")
                        
                        let type = json["type"].description
                        if type == "1" {
                            let str = json["result"][0].description
                            let user = Mapper<User>().map(JSONString: str)
                            AppDelegate.user = user
                            AppDelegate.user?.USER_CODE = name
                            wkSelf.saveUserNameAndPasswordInLocal(userName: name, passWord: pwd)
                            responseProtocol.responseSuccess()
                        } else {
                            let msg = json["msg"].description
                            responseProtocol.responseError(msg)
                        }
                    } else {
                        responseProtocol.responseError("登陆失败")
                    }
                }
            }
        }) { (Error) in
            DispatchQueue.main.async {
                responseProtocol.responseError("登陆失败")
                print(Error)
            }
        }
        
        
        //                Alamofire.request(URLConstants.loginUrl, method: .post, parameters: parameters).responseJSON { response in
        //                    weak var weakSelf = self
        //                    switch response.result {
        //                    case .success:
        //                        if let wkSelf = weakSelf {
        //                            if let value = response.result.value {
        //                                let json = JSON(value)
        //                                print("JSON: \(json)")
        //
        //                                let type = json["type"].description
        //                                if type == "1" {
        //                                    let str = json["result"][0].description
        //                                    let user = Mapper<User>().map(JSONString: str)
        //                                    AppDelegate.user = user
        //                                    AppDelegate.user?.USER_CODE = name
        //                                    wkSelf.saveUserNameAndPasswordInLocal(userName: name, passWord: pwd)
        //                                    responseProtocol.responseSuccess()
        //                                } else {
        //                                    let msg = json["msg"].description
        //                                    responseProtocol.responseError(msg)
        //                                }
        //                            }
        //                        }
        //                    case .failure(let error):
        //                        responseProtocol.responseError("登陆失败")
        //                        print(error)
        //                    }
        //                }
    }
    
    
    /**
     * 保存用户名和密码到本地
     *
     * userName: 用户名
     *
     * password: 用户登陆密码
     */
    fileprivate func saveUserNameAndPasswordInLocal (userName name: String, passWord pwd: String) {
        UserDefaults.standard.set(name, forKey: BusinessConstants.userName)
        UserDefaults.standard.set(pwd, forKey: BusinessConstants.passWord)
    }
    
    
    /**
     * 上传位置信息
     *
     * location: 位置信息 CLLocationCoordinate2D
     */
    func updataLocation (_ location: CLLocationCoordinate2D) {
        let localLocationPointList = getLocalLocationPointList()
        print("本地保存的位置点数据数量：\(localLocationPointList.count)")
        if localLocationPointList.count > 0 {//本地有缓存数据，先保存到本地在上传
            print("本地有缓存数据，先保存到本地在上传")
            saveLocationPointInLocal(location)
            updataCacheLocations()
        } else {//本地无保存位置点信息，直接上传
            print("本地无保存位置点信息，直接上传")
            updataOneLocation(location)
        }
    }
    
    /// 上传缓存的位置点信息集合
    fileprivate func updataCacheLocations () {
        print("上传缓存的位置点信息集合")
        let localLocationPointList = getLocalLocationPointList()
        if localLocationPointList.count > updataCacheLocationsCount {//超过单次上传数量，分批上传，每次上传20条数据（默认）
            print("超过单次上传数量，分批上传")
            var updataLocalLocationPointList = [LocationContineTime]()
            for i in 0 ..< updataCacheLocationsCount {
                updataLocalLocationPointList.append(localLocationPointList[i])
            }
            updataLocations(updataLocalLocationPointList)
        } else {//小于单次上传数量，直接上传
            print("小于单次上传数量，直接上传")
            updataLocations(localLocationPointList)
        }
    }
    
    /**
     * 将位置点信息保存到本地
     *
     * location: 位置信息 CLLocationCoordinate2D
     */
    internal func saveLocationPointInLocal (_ location: CLLocationCoordinate2D) {
        print("保存位置点信息到本地")
        let locationContineTime = changeCLLocationCoordinated2DToLocationContineTime(location)
        
        var locationContineTimeList = getLocalLocationPointList()
        locationContineTimeList.append(locationContineTime)
        
        //再次更改本地位置点数据中的 id ，确保 id 的值是顺序的，后台排序用
        let locationContineTimeCount = locationContineTimeList.count
        for i in 0 ..< locationContineTimeCount {
            locationContineTimeList[i].ID = "\(i)"
        }
        
        let locationContineTimeListStr = changeLocationContineTimeListToJsonString(locationContineTimeList)
        UserDefaults.standard.setValue(locationContineTimeListStr, forKey: "locationList")
        UserDefaults.standard.synchronize()
    }
    
    /**
     * 获取本地保存的位置点集合信息
     *
     * return 本地保存的位置点集合
     */
    fileprivate func getLocalLocationPointList () -> Array<LocationContineTime> {
        print("获取本地保存的位置点集合信息")
        let locationListData = UserDefaults.standard.string(forKey: "locationList")
        if let locationList = locationListData {
            let locationContineTimeList = changeJsonStringToLocationContineTimeList(locationList)
            return locationContineTimeList
        }
        print("本地无缓存数据")
        return [LocationContineTime]()
    }
    
    /**
     * 将百度地图的位置点信息转换成本地的 LocationContineTime
     *
     * location: 需要转换的位置点 CLLocationCoordinate2D
     *
     * return LocationContineTime
     */
    fileprivate func changeCLLocationCoordinated2DToLocationContineTime (_ location: CLLocationCoordinate2D) -> LocationContineTime {
        print("将百度地图的位置点信息转换成本地的 LocationContineTime")
        let locationContineTime = LocationContineTime()
        locationContineTime.ID = "\(getLocalLocationPointList().count)"
        locationContineTime.USERIDX = (AppDelegate.user?.IDX)!
        locationContineTime.ADDRESS = "默认code地址"
        locationContineTime.CORDINATEX = location.longitude
        locationContineTime.CORDINATEY = location.latitude
        locationContineTime.TIME = DateUtils.getCurrentDate()
        return locationContineTime
    }
    
    /**
     * 将位置信息点集合转换成 string
     *
     * list: 需要转换的位置点集合
     *
     * return 转换完的 json 格式的 string
     */
    fileprivate func changeLocationContineTimeListToJsonString (_ list: Array<LocationContineTime>) -> String {
        var i: Int = 1
        var str: String = "{\"result\":["
        for location in list {
            if i > 1 {
                str += ","
            }
            str += "{\"ID\":" + "\"\(location.ID)\"" + ",\"USERIDX\":" + "\"\(location.USERIDX)\""  + ",\"CORDINATEX\":" + "\"\(location.CORDINATEX)\"" + ",\"CORDINATEY\":" + "\"\(location.CORDINATEY)\"" + ",\"ADDRESS\":" + "\"\(location.ADDRESS)\"" + ",\"TIME\":" + "\"\(location.TIME)\"}"
            i += 1
        }
        str += "]}"
        print("将位置信息点集合转换成 string:\(str)")
        return str
    }
    
    /**
     * 将json格式的字符串转换成位置信息点集合
     *
     * str: 需要转换的位置点集合的 json 格式的 string
     *
     * return 转换完的位置点信息集合
     */
    fileprivate func changeJsonStringToLocationContineTimeList (_ str: String) -> Array<LocationContineTime> {
        print("将json格式的字符串转换成位置信息点集合")
        let testData = (str.data(using: String.Encoding.utf8))!
        let json = JSON(data: testData)
        let locationListJson = json["result"].arrayValue
        var locationContineTimeList = [LocationContineTime]()
        for locationJson in locationListJson {
            let locationContineTime = LocationContineTime()
            locationContineTime.ID = locationJson["ID"].description
            locationContineTime.USERIDX = locationJson["USERIDX"].description
            locationContineTime.CORDINATEX = (locationJson["CORDINATEX"].description as NSString).doubleValue
            locationContineTime.CORDINATEY = (locationJson["CORDINATEY"].description as NSString).doubleValue
            locationContineTime.ADDRESS = locationJson["ADDRESS"].description
            locationContineTime.TIME = locationJson["TIME"].description
            locationContineTimeList.append(locationContineTime)
        }
        return locationContineTimeList
    }
    
    
    /**
     * 上传单个位置点
     *
     * location: 需要上传的点
     */
    fileprivate func updataOneLocation (_ location: CLLocationCoordinate2D) {
        print("上传单个位置点")
        let parameters = [
            "strUserIdx": "\((AppDelegate.user?.IDX)!)",
            "cordinateX": "\(location.longitude)",
            "cordinateY": "\(location.latitude)",
            "address": "默认code地址",
            "date": DateUtils.getCurrentDate()+"",
            "strLicense": ""
        ]
        print(parameters)
        
        weak var weakSelf = self
        NetWorkBaseBiz().postWithPath(path: URLConstants.updataLocation, paras: parameters, success: { (result) in
            DispatchQueue.main.async {
                if let wkSelf = weakSelf {
                    
                    var dictReturn :NSDictionary? = nil
                    dictReturn = result as? NSDictionary
                    
                    if(dictReturn != nil) {
                        let json = JSON(dictReturn)
                        print("JSON: \(json)")
                        
                        let type = (json["type"].description as NSString).doubleValue
                        if type > 1 {//发送成功，并且需要更改上传定位时间间隔
                            if wkSelf.updataLocationSpanTimeMin != type {//需要更改上传时间间隔
                                print("需要更改上传时间间隔:更改为\(type)分钟")
                                wkSelf.updataLocationSpanTimeMin = type
                                wkSelf.isNeedChangeUpdataLocationSpanTime = true
                            }
                        } else if type < 1 {//发送失败
                            wkSelf.saveLocationPointInLocal(location)
                        }
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                if let wkSelf = weakSelf {
                    wkSelf.saveLocationPointInLocal(location)
                }
                print(error)
            }
        }
        
        
        //        Alamofire.request(URLConstants.updataLocation, method: .post, parameters: parameters)
        //            .responseJSON { response in
        //                switch response.result {
        //                case .success:
        //                    if let wkSelf = weakSelf {
        //                        if let value = response.result.value {
        //                            let json = JSON(value)
        //                            print("JSON: \(json)")
        //
        //                            let type = (json["type"].description as NSString).doubleValue
        //                            if type > 1 {//发送成功，并且需要更改上传定位时间间隔
        //                                if wkSelf.updataLocationSpanTimeMin != type {//需要更改上传时间间隔
        //                                    print("需要更改上传时间间隔:更改为\(type)分钟")
        //                                    wkSelf.updataLocationSpanTimeMin = type
        //                                    wkSelf.isNeedChangeUpdataLocationSpanTime = true
        //                                }
        //                            } else if type < 1 {//发送失败
        //                                wkSelf.saveLocationPointInLocal(location)
        //                            }
        //                        }
        //                    }
        //                case .failure(let error)://发送失败
        //                    if let wkSelf = weakSelf {
        //                        wkSelf.saveLocationPointInLocal(location)
        //                    }
        //                    print(error)
        //                }
        //        }
    }
    
    /**
     * 上传位置点集合
     *
     * locations: 需要上传的位置点集合
     */
    fileprivate func updataLocations (_ locations: Array<LocationContineTime>) {
        print("上传位置点集合")
        let parameters = [
            "strUserIdx": "\((AppDelegate.user?.IDX)!)",
            "strJson": changeLocationContineTimeListToJsonString(locations),
            "strLicense": ""
        ]
        
        print("打印位置点集合开始")
        print(parameters)
        print("打印位置点集合结束")
        
        weak var weakSelf = self
        NetWorkBaseBiz().postWithPath(path: URLConstants.updataLocations, paras: parameters, success: { (result) in
            DispatchQueue.main.async {
                if let wkSelf = weakSelf {
                    
                    var dictReturn :NSDictionary? = nil
                    dictReturn = result as? NSDictionary
                    
                    if(dictReturn != nil) {
                        let json = JSON(dictReturn)
                        print("JSON: \(json)")
                        
                        let type = (json["type"].description as NSString).doubleValue
                        if type >= 1 {//上传位置点信息集合成功
                            wkSelf.deleteUpdataLocationsFromLocal()
                            let localLocationList = wkSelf.getLocalLocationPointList()
                            if localLocationList.count > 0 {
                                print("本地还有位置点缓存数据，继续上传缓存本地位置点信息")
                                wkSelf.updataCacheLocations()
                            }
                            if type > 1 {//发送成功，并且需要更改上传定位时间间隔
                                if wkSelf.updataLocationSpanTimeMin != type {//需要更改上传时间间隔
                                    print("需要更改上传时间间隔:更改为\(type)分钟")
                                    wkSelf.updataLocationSpanTimeMin = type
                                    wkSelf.isNeedChangeUpdataLocationSpanTime = true
                                }
                            }
                        }
                    }
                }
            }
        }) { (error) in
            DispatchQueue.main.async {
                print(error)
            }
        }
        //        Alamofire.request(URLConstants.updataLocations, method: .post, parameters: parameters)
//            .responseJSON { response in
//                switch response.result {
//                case .success:
//                    if let wkSelf = weakSelf {
//                        if let value = response.result.value {
//                            let json = JSON(value)
//                            print("JSON: \(json)")
//                            
//                            let type = (json["type"].description as NSString).doubleValue
//                            if type >= 1 {//上传位置点信息集合成功
//                                wkSelf.deleteUpdataLocationsFromLocal()
//                                let localLocationList = wkSelf.getLocalLocationPointList()
//                                if localLocationList.count > 0 {
//                                    print("本地还有位置点缓存数据，继续上传缓存本地位置点信息")
//                                    wkSelf.updataCacheLocations()
//                                }
//                                if type > 1 {//发送成功，并且需要更改上传定位时间间隔
//                                    if wkSelf.updataLocationSpanTimeMin != type {//需要更改上传时间间隔
//                                        print("需要更改上传时间间隔:更改为\(type)分钟")
//                                        wkSelf.updataLocationSpanTimeMin = type
//                                        wkSelf.isNeedChangeUpdataLocationSpanTime = true
//                                    }
//                                }
//                            }
//                        }
//                    }
//                case .failure(let error)://发送失败
//                    print(error)
//                }
//        }
    }
    
    /// 从本地保存的位置信息中删除上传完的位置信息集合
    fileprivate func deleteUpdataLocationsFromLocal () {
        print("从本地保存的位置信息中删除上传完的位置信息集合")
        let localLocationsList = getLocalLocationPointList()
        var newLocalLocationList = [LocationContineTime]()
        if localLocationsList.count > 20 {
            let localLocationListCount = localLocationsList.count
            for i in updataCacheLocationsCount ..< localLocationListCount {
                let location = localLocationsList[i]
                //更改本地位置点数据中的 id 后台排序用
                location.ID = "\((location.ID as NSString).integerValue - updataCacheLocationsCount)"
                newLocalLocationList.append(localLocationsList[i])
            }
        }
        
        let locationContineTimeListStr = changeLocationContineTimeListToJsonString(newLocalLocationList)
        UserDefaults.standard.setValue(locationContineTimeListStr, forKey: "locationList")
        UserDefaults.standard.synchronize()
    }
    
}
