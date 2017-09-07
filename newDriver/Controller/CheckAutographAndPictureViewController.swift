//
//  CheckAutographAndPictureViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/30.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class CheckAutographAndPictureViewController: UIViewController, HttpResponseProtocol {

    
    /// 用户的 idx
    var orderIDX: String = ""
    
    /// 查看订单线路的业务类
    var biz: CheckAutographAndPictureBiz = CheckAutographAndPictureBiz()
    
    /// 客户签名控件
    @IBOutlet weak var autographField: UIImageView!
    @IBOutlet weak var spinnerAutograph: UIActivityIndicatorView! {
        didSet {
            spinnerAutograph.startAnimating()
        }
    }
    
    /// 进入查看客户签名大图
    @IBAction func checkAutographDetail(_ sender: UIButton) {
        skipToZoomImageViewController(biz.getPictureUrl(0))
    }
    
    /// 现场图片1
    @IBOutlet weak var picture1Field: UIImageView!
    @IBOutlet weak var picture1Spinner: UIActivityIndicatorView! {
        didSet {
            picture1Spinner.startAnimating()
        }
    }
    
    /// 进入查看现场图片1大图
    @IBAction func checkPicture1Detail(_ sender: UIButton) {
        skipToZoomImageViewController(biz.getPictureUrl(1))
    }
    
    /// 现场图片2
    @IBOutlet weak var picture2Field: UIImageView!
    @IBOutlet weak var picture2Spinner: UIActivityIndicatorView! {
        didSet {
            picture2Spinner.startAnimating()
        }
    }
    
    /// 进入查看现场图片2大图
    @IBAction func checkPicture2Detail(_ sender: UIButton) {
        skipToZoomImageViewController(biz.getPictureUrl(2))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "查看签名、图片"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //判断连接状态
        let reachability = Reachability.forInternetConnection()
        if reachability!.isReachable(){
            biz.getOrderAutographAndPicture(orderIDX: orderIDX, httpresponseProtocol: self)
        }else{
            self.responseError("网络连接不可用!")
        }
    }

    /// 获取订单点子签名和现场图片成功回调
    func responseSuccess() {
        setImageFieldImage(biz.getPictureUrl(0), imageView: autographField)
        spinnerAutograph.stopAnimating()
        setImageFieldImage(biz.getPictureUrl(1), imageView: picture1Field)
        picture1Spinner.stopAnimating()
        setImageFieldImage(biz.getPictureUrl(2), imageView: picture2Field)
        picture2Spinner.stopAnimating()
    }
    
    /**
     * 获取电子签名和图片失败回调方法
     *
     * message: 显示的信息
     */
    func responseError(_ error: String) {
        Tools.showAlertDialog(error, self)
        spinnerAutograph.stopAnimating()
        picture1Spinner.stopAnimating()
        picture2Spinner.stopAnimating()
    }
    
    /**
     * 设置 imageview 的图片
     *
     * imageUrl: 图片的网络路径
     *
     * imageView: 显示图片的控件
     */
    fileprivate func setImageFieldImage (_ imageUrl: String, imageView: UIImageView) {
        if !imageUrl.isEmpty {
            let url = URL(string: imageUrl)
            if let u = url {
                let imageData = try? Data(contentsOf: u)
                if let data = imageData {
                    let image = UIImage(data: data)
                    imageView.image = image
                }
            }
        }
    }
    
    /**
     * 跳转到查看大图界面
     *
     * imageUrl: 图片网络路径
     */
    fileprivate func skipToZoomImageViewController (_ imageUrl: String) {
        if !imageUrl.isEmpty {
            let zoomImageViewController = ZoomImageViewViewController(nibName: "ZoomImageViewViewController", bundle: nil)
            zoomImageViewController.imageUrl = imageUrl
            self.navigationController?.pushViewController(zoomImageViewController, animated: true)
        }
    }
}
