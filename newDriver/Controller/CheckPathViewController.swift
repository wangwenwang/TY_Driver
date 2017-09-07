//
//  CheckPathViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit
import MapKit


class CheckPathViewController: UIViewController, BMKMapViewDelegate, BMKRouteSearchDelegate, HttpResponseProtocol {
    
    
    /// 订单状态，用来确定显示的“途中”或“终点”图标。（默认终点）
    var driver_pay : Int = 1;
    
    /// 用户的 idx
    var orderIDX: String = ""
    
    /// 查看订单线路业务类
    fileprivate var biz = CheckPathBiz()
    
    /// 订单线路长度
    fileprivate var orderPathDistance: Int32 = 0
    
    /// 已经规划完路线的位置点
    fileprivate var startSearchPoint: Int = 0
    
    /// 已经规划完路线的位置点
    fileprivate var startSearchPoint1: Int = 0
    
    /// 是否是让地图缩放到包含线路
    fileprivate var isJustFitMapWithPolyLine: Bool = true
    
    /// 百度地图查询路线
    var routeSearch: BMKRouteSearch!
    
    /// 路线长度
    @IBOutlet weak var pathDistanceField: UILabel! {
        didSet {
            //            pathDistanceField.alpha = 0.0
        }
    }
    
    /// 百度地图控件
    @IBOutlet weak var mapViwe: MyBMKMapView!
    
    /// 加载数据和线路时显示的控件
    @IBOutlet weak var progressField: UIView!
    @IBOutlet weak var progress: UIActivityIndicatorView! {
        didSet {
            progress.startAnimating()
        }
    }
    
    // 规划路线 10个点一批 判断是否最后一批
    var pathPointLast : Bool = false
    
    
    // MARK: 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "查看路线"
        mapViwe.zoomLevel = 15
        routeSearch = BMKRouteSearch()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapViwe.viewWillAppear()
        mapViwe.delegate = self
        routeSearch.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapViwe.viewWillDisappear()
        mapViwe.delegate = nil
        routeSearch.delegate = nil
    }
    
    
    // MARK: BMKMapViewDelegate回调
    
    // 百度地图初始化完成
    func mapViewDidFinishLoading(_ mapView: BMKMapView!) {
        //判断连接状态
        let reachability = Reachability.forInternetConnection()
        if reachability!.isReachable(){
            biz.getOrderLocaltions(orderIdx: orderIDX, httpresponseProtocol: self)
        }else{
            self.responseError("网络连接不可用!")
        }
    }
    
    
    // 根据polyline设置地图范围
    func mapViewFitPolyLine(_ polyline: BMKPolyline!) {
        if polyline.pointCount < 1 {
            return
        }
        
        let pt = polyline.points[0]
        var ltX = pt.x
        var rbX = pt.x
        var ltY = pt.y
        var rbY = pt.y
        
        for i in 1..<polyline.pointCount {
            let pt = polyline.points[Int(i)]
            if pt.x < ltX {
                ltX = pt.x
            }
            if pt.x > rbX {
                rbX = pt.x
            }
            if pt.y > ltY {
                ltY = pt.y
            }
            if pt.y < rbY {
                rbY = pt.y
            }
        }
        
        let rect = BMKMapRectMake(ltX, ltY, rbX - ltX, rbY - ltY)
        mapViwe.visibleMapRect = rect
        mapViwe.zoomLevel = mapViwe.zoomLevel - 0.5
    }
    
    
    /**
     *根据overlay生成对应的View
     *@param mapView 地图View
     *@param overlay 指定的overlay
     *@return 生成的覆盖物View
     */
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if overlay as! BMKPolyline? != nil {
            let polylineView = BMKPolylineView(overlay: overlay as! BMKPolyline)
            polylineView?.strokeColor = UIColor.red
            polylineView?.lineWidth = 3
            return polylineView
        }
        return nil
    }
    
    /**
     *根据anntation生成对应的View
     *@param mapView 地图View
     *@param annotation 指定的标注
     *@return 生成的标注View
     */
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if let routeAnnotation = annotation as! RouteAnnotation? {
            return getViewForRouteAnnotation(routeAnnotation)
        }
        return nil
    }
    
    
    // MARK: BMKRouteSearchDelegate
    
    /**
     * 搜索架车路线
     */
    fileprivate func searchDrivingPath () {
        let points = biz.orderLocations
        
        if(startSearchPoint1 >= points.count - 2) {
            
            return
        }
        
        // 声明变量
        let from = BMKPlanNode()
        let to = BMKPlanNode()
        var passBys: [BMKPlanNode] = []
        
        // 用11个点缩放地图，起、途中9个点、终
        if(isJustFitMapWithPolyLine) {
            
            // 起点
            let startPoint = points[0]
            // 途中
            var i : CGFloat = 0.1
            while (i <= 0.9) {
                let count : CGFloat = CGFloat(points.count)
                let passBy = BMKPlanNode()
                let j : Int = (Int)(count * i)
                let passByLocalPoint : Location = points[j]
                passBy.pt = CLLocationCoordinate2DMake(passByLocalPoint.CORDINATEY, passByLocalPoint.CORDINATEX)
                passBys.append(passBy)
                print("count:\(count)  j:\(j)")
                i += 0.1
            }
            // 终点
            let endPoint = points[points.count - 1]
            from.pt = CLLocationCoordinate2DMake(startPoint.CORDINATEY, startPoint.CORDINATEX)
            to.pt = CLLocationCoordinate2DMake(endPoint.CORDINATEY, endPoint.CORDINATEX)
        } else {
            
            // 检出本途中点个数
            var fori : Int = 0
            if((points.count - startSearchPoint1 - 2) > 10) {
                
                fori = 10
            } else {
                
                fori = points.count - startSearchPoint1 - 2
                pathPointLast = true
            }
            
            
            // 起点
            let startPoint = points[startSearchPoint1]
            // 途中
            for _ in 0..<fori {
                startSearchPoint1 += 1
                let passBy = BMKPlanNode()
                let passByLocalPoint : Location = points[startSearchPoint1]
                passBy.pt = CLLocationCoordinate2DMake(passByLocalPoint.CORDINATEY, passByLocalPoint.CORDINATEX)
                passBys.append(passBy)
            }
            // 终点
            let endPoint = points[startSearchPoint1 + 1]
            
            from.pt = CLLocationCoordinate2DMake(startPoint.CORDINATEY, startPoint.CORDINATEX)
            to.pt = CLLocationCoordinate2DMake(endPoint.CORDINATEY, endPoint.CORDINATEX)
        }
        
        let drivingRouteSearchOption = BMKDrivingRoutePlanOption()
        drivingRouteSearchOption.from = from
        drivingRouteSearchOption.wayPointsArray = passBys
        drivingRouteSearchOption.to = to
        drivingRouteSearchOption.drivingRequestTrafficType = BMK_DRIVING_REQUEST_TRAFFICE_TYPE_PATH_AND_TRAFFICE
        
        let flag = routeSearch.drivingSearch(drivingRouteSearchOption)
        if flag {
            print("驾乘检索发送成功")
        }else {
            print("驾乘检索发送失败")
            dismissProgress()
            Tools.showAlertDialog("规划失败!", self)
        }
    }
    
    /**
     * 添加起点和终点图标
     *
     * start: 起点位置
     *
     * end： 终点位置
     */
    fileprivate func addStartAndEndPointMark (_ start: Location, end: Location) {
        let startItem = RouteAnnotation()
        startItem.coordinate = CLLocationCoordinate2D(latitude: start.CORDINATEY, longitude: start.CORDINATEX)
        startItem.title = "起点"
        startItem.type = 0
        mapViwe.addAnnotation(startItem)  // 添加起点标注
        
        let endItem = RouteAnnotation()
        endItem.coordinate = CLLocationCoordinate2D(latitude: end.CORDINATEY, longitude: end.CORDINATEX)
        endItem.title = "终点"
        endItem.type = driver_pay;
        mapViwe.addAnnotation(endItem)  // 添加终点标注
    }
    
    
    var pathDistance : Int32 = 0
    
    /**
     *返回驾乘搜索结果
     *@param searcher 搜索对象
     *@param result 搜索结果，类型为BMKDrivingRouteResult
     *@param error 错误号，@see BMKSearchErrorCode
     */
    func onGetDrivingRouteResult(_ searcher: BMKRouteSearch!, result: BMKDrivingRouteResult!, errorCode error: BMKSearchErrorCode) {
        print("onGetDrivingRouteResult: \(error)")
        
        dismissProgress()
        
        if error == BMK_SEARCH_NO_ERROR {
            let plan = result.routes[0] as! BMKDrivingRouteLine
            
            let size = plan.steps.count
            var planPointCounts = 0
            for i in 0..<size {
                let transitStep = plan.steps[i] as! BMKDrivingStep
                
                // 添加 annotation 节点
                let item = RouteAnnotation()
                item.coordinate = transitStep.entrace.location
                item.title = transitStep.instruction
                item.degree = Int(transitStep.direction) * 30
                item.type = 4
                mapViwe.addAnnotation(item)
                
                // 轨迹点总数累计
                planPointCounts = Int(transitStep.pointsCount) + planPointCounts
            }
            
            // 轨迹点
            var tempPoints = Array(repeating: BMKMapPoint(x: 0, y: 0), count: planPointCounts)
            var i = 0
            for j in 0..<size {
                let transitStep = plan.steps[j] as! BMKDrivingStep
                for k in 0..<Int(transitStep.pointsCount) {
                    tempPoints[i].x = transitStep.points[k].x
                    tempPoints[i].y = transitStep.points[k].y
                    i += 1
                }
            }
            
            // 通过 points 构建 BMKPolyline
            let polyLine = BMKPolyline(points: &tempPoints, count: UInt(planPointCounts))
            // 添加路线 overlay
            if(isJustFitMapWithPolyLine) {
                mapViewFitPolyLine(polyLine)
                isJustFitMapWithPolyLine = false
            } else {
                mapViwe.add(polyLine)
                
                // 统计总距离
                pathDistance = pathDistance + plan.distance
                let distance : CGFloat = CGFloat(pathDistance) / 1000.0
                let strDistance : String = String.init(format:"%.1f", distance)
                if pathPointLast == true {
                    
                    pathDistanceField.text = "路线长度：\(strDistance)公里"
                } else {
                    
                    pathDistanceField.text = "路线长度：\(strDistance)公里 统计中..."
                }
            }
            
            // 递归回调
            searchDrivingPath()
        }
    }
    
    
    /**
     * 根据 RouteAnnotation 的类型获取对应的图标
     *
     * routeAnnotation: RouteAnnotation
     *
     * return 对应类型的图标
     */
    func getViewForRouteAnnotation(_ routeAnnotation: RouteAnnotation!) -> BMKAnnotationView? {
        var view: BMKAnnotationView?
        
        var imageName: String!
        switch routeAnnotation.type {
        case 0:
            imageName = "nav_start"
        case 1:
            imageName = "nav_end"
        case 2:
            imageName = "nav_bus"
        case 3:
            imageName = "nav_rail"
        case 4:
            imageName = "direction"
        case 5:
            imageName = "nav_waypoint"
        default:
            return nil
        }
        let identifier = "\(imageName)_annotation"
        view = mapViwe.dequeueReusableAnnotationView(withIdentifier: identifier)
        if view == nil {
            view = BMKAnnotationView(annotation: routeAnnotation, reuseIdentifier: identifier)
            view?.centerOffset = CGPoint(x: 0, y: -(view!.frame.size.height * 0.5))
            view?.canShowCallout = true
        }
        
        view?.annotation = routeAnnotation
        
        let bundlePath = (Bundle.main.resourcePath)! + "/mapapi.bundle/"
        let bundle = Bundle(path: bundlePath)
        
        let imagePath : String = (bundle?.resourcePath)! + "/images/icon_\(imageName!).png"
        var image = UIImage(contentsOfFile: imagePath)
        if routeAnnotation.type == 4 {
            image = imageRotated(image, degrees: routeAnnotation.degree)
        }
        if image != nil {
            view?.image = image
        }
        
        return view
    }
    
    
    // MARK: 功能函数
    
    /**
     * 旋转图片
     *
     * image: 需要旋转的图片
     *
     * degrees: 旋转的角度
     *
     * return 旋转后的图片
     */
    func imageRotated(_ image: UIImage!, degrees: Int!) -> UIImage {
        let width = image.cgImage?.width
        let height = image.cgImage?.height
        let rotatedSize = CGSize(width: width!, height: height!)
        UIGraphicsBeginImageContext(rotatedSize);
        let bitmap = UIGraphicsGetCurrentContext();
        bitmap?.translateBy(x: rotatedSize.width/2, y: rotatedSize.height/2);
        bitmap?.rotate(by: CGFloat(Double(degrees) * M_PI / 180.0));
        bitmap?.rotate(by: CGFloat(M_PI));
        bitmap?.scaleBy(x: -1.0, y: 1.0);
        bitmap?.draw(image.cgImage!, in: CGRect(x: -rotatedSize.width/2, y: -rotatedSize.height/2, width: rotatedSize.width, height: rotatedSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
    }
    
    /// 显示获取订单线路位置集合和规划线路时显示的进度
    fileprivate func showProgress () {
        progress.startAnimating()
        progressField.alpha = 1.0
    }
    
    /// 隐藏获取订单线路位置集合和规划线路时显示的进度
    fileprivate func dismissProgress () {
        progress.stopAnimating()
        progressField.alpha = 0.0
    }
    
    
    // MARK: HttpResponseProtocol回调
    
    /// 获取订单线路位置集合成功
    func responseSuccess() {
        let points = biz.orderLocations
        
        if(points.count > 2) {
            
            addStartAndEndPointMark(points[0], end: points[points.count-1])
            searchDrivingPath()
        } else {
            
            self.dismissProgress()
            Tools.showAlertDialog("记录的位置点为\(points.count),小于3个点不能规划线路", self)
            return
        }
    }
    
    /**
     * 获取订单线路位置集合失败回调方法
     *
     * message: 显示的信息
     */
    func responseError(_ error: String) {
        
        dismissProgress()
        pathDistanceField.text = "没有数据，无法统计距离"
        Tools.showAlertDialog(error, self)
    }
}
