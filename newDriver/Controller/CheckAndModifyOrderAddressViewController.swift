//
//  CheckAndModifyOrderAddressViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/11/10.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit
import MapKit

class CheckAndModifyOrderAddressViewController: UIViewController, BMKMapViewDelegate {
    
    /// 坐标
    var _coordinate : CLLocationCoordinate2D!
    
    /// 转换高德地图的坐标
    var _coordinate_GaoDe : CLLocationCoordinate2D!
    
    /// 地址
    var _address : String!
    
    /// 地图名字
    var _mapName : String!
    
    @IBOutlet weak var mapView: BMKMapView!
    
    var pointAnnotation: BMKPointAnnotation?
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.zoomLevel = 17
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView?.viewWillAppear()
        mapView?.delegate = self
        self.title = "确认目的地址"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global().async {
            usleep(500000)
            DispatchQueue.main.async {
                self.mapView.setCenter(self._coordinate, animated: true)
                DispatchQueue.global().async {
                    usleep(500000)
                    DispatchQueue.main.async {
                        self.addPointAnnotation(self._coordinate)
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.viewWillDisappear()
        mapView?.delegate = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    @IBAction func backOnclick(_ sender: UIButton) {
        self.dismiss(animated: true) { }
    }
    
    @IBAction func startNavigationOnclick(_ sender: UIButton) {
        
        toMaps(_mapName)
    }
    
    // MARK: - 添加标注
    func addPointAnnotation(_ coordinate: CLLocationCoordinate2D) {
        if pointAnnotation != nil {
            mapView!.removeAnnotation(pointAnnotation)
        }
        pointAnnotation = BMKPointAnnotation()
        pointAnnotation?.coordinate = coordinate
        pointAnnotation?.title = "点击地图任意位置可移动"
        pointAnnotation?.subtitle = "目的地点：\(_address)"
        mapView!.addAnnotation(pointAnnotation)
    }
    
    // MARK: - BMKMapViewDelegate
    
    /**
     *点中底图空白处会回调此接口
     *@param mapview 地图View
     *@param coordinate 空白处坐标点的经纬度
     */
    func mapView(_ mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        
        addPointAnnotation(coordinate)
        _coordinate = coordinate
        _coordinate_GaoDe = bdToGaoDe(coordinate)
        print(coordinate)
    }
    
    func mapView(_ mapView: BMKMapView!, onClickedMapPoi mapPoi: BMKMapPoi!) {
        
        addPointAnnotation(mapPoi.pt)
        _coordinate = mapPoi.pt
        _coordinate_GaoDe = bdToGaoDe(mapPoi.pt)
        print(mapPoi.pt)
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        // 普通标注
        if (annotation as! BMKPointAnnotation) == pointAnnotation {
            let AnnotationViewID = "renameMark"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationViewID) as! BMKPinAnnotationView?
            if annotationView == nil {
                annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)
                // 设置颜色
                annotationView!.pinColor = UInt(BMKPinAnnotationColorPurple)
                // 从天上掉下的动画
                annotationView!.animatesDrop = true
                
                annotationView?.canShowCallout = true
                // 设置可拖曳
                //                annotationView!.draggable = true
            }
            annotationView?.annotation = annotation
            return annotationView
        }
        return nil
    }
    
    func toMaps(_ name : String) {
        if(name == "苹果自带地图") {
            
            print("苹果自带地图")
            let currentLocation : MKMapItem = MKMapItem.forCurrentLocation()
            let toLocation : MKMapItem = MKMapItem.init(placemark: MKPlacemark.init(coordinate: _coordinate_GaoDe, addressDictionary: nil))
            toLocation.name = _address
            MKMapItem.openMaps(with: [currentLocation, toLocation], launchOptions:[MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey : NSNumber.init(value: false as Bool)])
            
        } else if(name == "高德地图") {
            
            print("高德地图")
            var urlString : String = "iosamap://navi?sourceApplication=货易(司机)&backScheme=回来&poiname=\(_address)&lat=\(_coordinate_GaoDe.latitude)&lon=\(_coordinate_GaoDe.longitude)&dev=0&style=2"
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            UIApplication.shared.openURL(URL(string: urlString)!)
            
        } else if(name == "百度地图") {
            
            print("百度地图")
            var urlString : String = "baidumap://map/direction?origin={{我的位置}}&destination=latlng:\(_coordinate_GaoDe.latitude),\(_coordinate_GaoDe.longitude)|name=目的地&mode=driving&coord_type=gcj02"
            urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            UIApplication.shared.openURL(URL(string: urlString)!)
            
        } else if(name == "谷歌地图") {
            
            Tools.showAlertDialog("正在建设中...", self)
            print("谷歌地图")
        }
        
        print("传出坐标:\(_coordinate)")
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
}
