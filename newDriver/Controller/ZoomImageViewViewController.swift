//
//  ZoomImageViewViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/7/1.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class ZoomImageViewViewController: UIViewController, UIScrollViewDelegate {

    
    /// 图片网络路径
    var imageUrl: String = ""
    
    /// 图片
    var imagePicture: UIImage?
    
    /// 显示图片的控件
    fileprivate var imageView = UIImageView()
    
    /// 缩放后的图片
    fileprivate var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            
            // width偏大多少
            let scan_width: CGFloat = SCREEN_WIDTH / imageView.frame.size.width
            
            // height偏大多少
            let scan_height: CGFloat = SCREEN_HEIGH / imageView.frame.size.height
            
            let scan_min = min(scan_width, scan_height)
            
            if(scan_min < 1) {
                
                setImageViewCenter(scan_min)
            } else {
                
               setImageViewCenter(1.0)
            }
            scrollViewField?.contentSize = imageView.frame.size
        }
    }
    
    /// 返回上一个场景
    @IBAction func goBack(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    /// 下载时显示的等待进度
    @IBOutlet weak var spinnerField: UIActivityIndicatorView! {
        didSet {
            spinnerField.startAnimating()
        }
    }
    
    /// 图片查看的 scrollview
    @IBOutlet weak var scrollViewField: UIScrollView! {
        didSet {
            scrollViewField.contentSize = imageView.frame.size
            scrollViewField.delegate = self
            scrollViewField.minimumZoomScale = 0.3
            scrollViewField.maximumZoomScale = 5.0
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
            setImageViewCenter(scale)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        scrollViewField.addSubview(imageView)
        fechImage()
    }

    /// 为 imageviw 添加图片
    fileprivate func fechImage() {
        if !imageUrl.isEmpty {
            weak var wkSelf = self
            spinnerField?.startAnimating()
            let qos = DispatchQoS.QoSClass.userInitiated
            DispatchQueue.global(qos: qos).async(execute: { () -> Void in
                let url = URL(string: (wkSelf?.imageUrl)!)
                if let u = url {
                    let imageData = try? Data(contentsOf: u)
                    DispatchQueue.main.async {
                        if let data = imageData {
                            wkSelf?.image = UIImage(data: data)
                            wkSelf?.spinnerField.stopAnimating()
                        }
                    }
                }
            })
        } else if let im = imagePicture {
            self.image = im
            spinnerField.stopAnimating()
        }
    }
    
    /*
     * 设置图片居中
     * 
     * scalSize: 图片缩放的比例
     */
    fileprivate func setImageViewCenter (_ scalSize: CGFloat) {
        let imageHeight = (image?.size.height)! * scalSize
        let imageWidth = (image?.size.width)! * scalSize
        let viewHeight = self.view.frame.height
        let viewWidth = (MainViewController.natigationBarWidth)!
        
        var topTranslate: CGFloat = -20
        if imageHeight < viewHeight {
            topTranslate = topTranslate + (viewHeight - imageHeight)/2
        }
        
        var leftTranslate: CGFloat = 0
        if imageWidth < viewWidth {
            leftTranslate = (viewWidth - imageWidth)/2
        }
        
        imageView.frame = CGRect(x: leftTranslate, y: topTranslate, width: imageWidth, height: imageHeight)
    }
    

}
