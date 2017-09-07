//
//  PayOrderViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/29.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit
import MobileCoreServices

class PayOrderViewController: UIViewController, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HttpResponseProtocol, UIActionSheetDelegate {
    
    var pickerController : UIImagePickerController? = nil;
    
    /// 取消、提交这两个按钮离底部的距离
    let buttomViewToButtom : CGFloat = 10;
    
    /// 订单的 idx
    var orderIDX: String = ""
    
    /// 交付订单业务类
//    let biz: PayOrderBiz = PayOrderBiz()
    
    let biz: DriverListPayBiz = DriverListPayBiz()
    
    
    /// 签名图片
    var autograph: UIImage?
    
    /// 现场图片1
    var image1: UIImage? {
        didSet {
            picture1Field.image = image1
        }
    }
    
    /// 现场图片2
    var image2: UIImage? {
        didSet {
            picture2Field.image = image2
        }
    }
    
    /// 选择现场图片的角标，1 现场图片1，2 现场图片2
    var currentUpdataPictureIndex: Int = 0
    
    /// 底部取消、上次按钮控件容器
    @IBOutlet weak var bottomButtonContioner: UIView!
    
    /// 存放签名控件
    @IBOutlet weak var autographField: AutographUIView!
    
    /// 现场图片1显示控件
    @IBOutlet weak var picture1Field: UIImageView!
    
    /// 现场图片2显示控件
    @IBOutlet weak var picture2Field: UIImageView!
    
    /// 提交订单时显示的背景
    @IBOutlet weak var progressField: UIView!
    @IBOutlet weak var progressBarField: UIActivityIndicatorView!
    
    /// 备注订单单号，可不输入
    @IBOutlet weak var remarkOrderNoLabel: UITextField!
    
    /// ScrollContent视图高度（内容高度）
    @IBOutlet weak var scrollContentViewHeight: NSLayoutConstraint!
    
    /// 填充高度
    @IBOutlet weak var buttomHeight: NSLayoutConstraint!
    
    /// ScrollView
    @IBOutlet weak var myScrollView: UIScrollView!
    
    /// 覆盖在 imageview1 上的按钮
    @IBAction func updataOrCheckPicture1(_ sender: UIButton) {
        currentUpdataPictureIndex = 1
        if let image = image1 {
            let zoomImageViewController = ZoomImageViewViewController(nibName: "ZoomImageViewViewController", bundle: nil)
            zoomImageViewController.imagePicture = image
            self.navigationController?.pushViewController(zoomImageViewController, animated: true)
        } else {
            showUpdataPictureWay()
        }
    }
    
    /// 上传图片1按钮
    @IBAction func updataPicture1(_ sender: UIButton) {
        currentUpdataPictureIndex = 1
        showUpdataPictureWay()
    }
    
    /// 覆盖在 imageview2 上的按钮
    @IBAction func updataOrCheckPicture2(_ sender: UIButton) {
        currentUpdataPictureIndex = 2
        if let image = image2 {
            let zoomImageViewController = ZoomImageViewViewController(nibName: "ZoomImageViewViewController", bundle: nil)
            zoomImageViewController.imagePicture = image
            self.navigationController?.pushViewController(zoomImageViewController, animated: true)
        } else {
            showUpdataPictureWay()
        }
    }
    
    /// 上传图片2按钮
    @IBAction func updataPicture2(_ sender: UIButton) {
        currentUpdataPictureIndex = 2
        showUpdataPictureWay()
    }
    
    /// 重新签名按钮
    @IBAction func clearAutographField(_ sender: UIButton) {
        autographField.backImage()
    }
    
    /// 输入文字时，点击背景收回键盘用
    @IBOutlet weak var textCoverView: UIView!
    
    /// 回收键盘手势
    @IBAction func recyclyKeyboardOnclick(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    fileprivate var locationBiz = LoginBiz()
    
    // MARK: - 生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单交付"
        
        // 创建相册
        createData()
        
        dismissProgress()
        
        // 追加键盘监听
        addNotification()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        scrollContentViewHeight.constant = UIScreen.main.bounds.height - 64 - buttomViewToButtom
    }
    
    deinit {
        removeNotification()
    }
    
    // MARK: - 私有方法
    /// 追加键盘监听
    fileprivate func addNotification () {
        NotificationCenter.default.addObserver(self, selector: #selector(PayOrderViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PayOrderViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /// 删除键盘监听
    fileprivate func removeNotification () {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 添加底部取消和提交订单按钮
    fileprivate func addCancelAndPayOrderButton () {
        let superViewHeight = bottomButtonContioner.frame.height
        let superViewWidth = (self.navigationController?.navigationBar.frame.width)! - 16
        let paddingWidth: CGFloat = 10.0
        let bottomButtonWidth = (superViewWidth - paddingWidth*3) / 2
        
        let cancelCGRect = CGRect(x: paddingWidth, y: 0, width: bottomButtonWidth, height: superViewHeight)
        let cancelButton = UIButton(frame: cancelCGRect)
        cancelButton.setTitle("取消", for: UIControlState())
        cancelButton.setTitleColor(UIColor.white, for: UIControlState())
        cancelButton.setBackgroundImage(UIImage(named: "ic_button_normal.png"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(PayOrderViewController.cancelPayOrder(_:)), for: UIControlEvents.touchUpInside)
        bottomButtonContioner.addSubview(cancelButton)
        
        let payOrderCGRect = CGRect(x: bottomButtonWidth + paddingWidth*2, y: 0, width: bottomButtonWidth, height: superViewHeight)
        let payOrderButton = UIButton(frame: payOrderCGRect)
        payOrderButton.setTitle("提交", for: UIControlState())
        payOrderButton.setTitleColor(UIColor.white, for: UIControlState())
        payOrderButton.setBackgroundImage(UIImage(named: "ic_button_normal.png"), for: UIControlState())
        payOrderButton.addTarget(self, action: #selector(PayOrderViewController.payOrder(_:)), for: UIControlEvents.touchUpInside)
        bottomButtonContioner.addSubview(payOrderButton)
    }
    
    // MARK: - 点击事件
    /// 取消交付，返回到物流信息场景
    @IBAction func cancelPayOrder(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    /// 提交订单
    @IBAction func payOrder(_ sender: UIButton) {
        //        showProgress()
        //        dispatch_async(dispatch_get_global_queue(0, 0)) {
        //            sleep(3)
        //            dispatch_async(dispatch_get_main_queue(), {
        //                self.responseSuccess()
        //            })
        //        }
        
        UIGraphicsBeginImageContext(autographField.bounds.size) // 开始截取画图板
        autographField.layer.render(in: UIGraphicsGetCurrentContext()!)
        autograph = UIGraphicsGetImageFromCurrentImageContext() // 截取到的图像
        UIGraphicsEndImageContext() // 结束截取
        
        if autographField.allLine.count < 1 {
            Tools.showAlertDialog("请签名后再提交！", self)
            return
        }
        if image1 == nil {
            Tools.showAlertDialog("请上上传现场图片1再提交！", self)
            return
        }
        if image2 == nil {
            Tools.showAlertDialog("请上上传现场图片2再提交！", self)
            return
        }
        
        let autographStr = biz.changeImageToString(autograph)
        let image1Str = biz.changeImageToString(image1)
        let image2Str = biz.changeImageToString(image2)
        let deliveStr : String = (remarkOrderNoLabel.text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        
        //判断连接状态
        let reachability = Reachability.forInternetConnection()
        if reachability!.isReachable(){
            showProgress()
            biz.payOrderWithPicture(orderIdx: orderIDX, autographStr: autographStr, image1Str: image1Str, image2Str: image2Str, deliveNoStr: deliveStr, httpresponseProtocol: self)
        }else{
            self.responseError("网络连接不可用!")
        }
    }
    
    // MARK: - 拍照回调
    /// 选择图片完成或拍照完成返回信息
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        if let im = image {
            let data = image?.compressImage(im, maxLength: 568*32, maxWidthOrHeight: 568*2)
            if let da = data {
                image = UIImage(data: da)
            }
        }
        if image != nil {
            switch currentUpdataPictureIndex {
            case 1://添加的是现场图片1
                image1 = image
            case 2://添加的是现场图片2
                image2 = image
            default:
                break
            }
        }
    }
    
    /// 取消选择图片或拍照
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 交订单回调
    /// 提交订单成功回调
    func responseSuccess() {
        let vcl = navigationController?.viewControllers[0]
        NotPayTableViewController.shouldRefresh = true
        
        let hud: MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.navigationController!.view, animated: true)
        
        // Configure for text only and offset down
        hud.mode = .text
        hud.labelText = "提交订单成功，即将返回..."
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 2)
        
        //判断连接状态
        let reachability = Reachability.forInternetConnection()
        
        if reachability!.isReachable(){
            locationBiz.updataLocation(AppDelegate.location)
        }else{
            locationBiz.saveLocationPointInLocal(AppDelegate.location)
        }
        
        //提交订单成功后上传一个位置点
        DispatchQueue.global().async {
            sleep(2)
            DispatchQueue.main.async {
                _ = self.navigationController?.popToViewController(vcl!, animated: true)
            }
        }
    }
    
    /**
     * 提交订单失败回调方法
     *
     * message: 显示的信息
     */
    func responseError(_ error: String) {
        dismissProgress()
        Tools.showAlertDialog(error, self)
    }
    
    // MARK: - HUB
    /// 隐藏提交订单时显示的背景
    fileprivate func dismissProgress () {
        progressBarField.stopAnimating()
        progressField.alpha = 0.0
    }
    
    /// 显示提交订单时显示的背景
    fileprivate func showProgress () {
        progressBarField.startAnimating()
        progressField.alpha = 1.0
    }
    
    /// return 键盘回收
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (remarkOrderNoLabel == textField) {
            self.view.endEditing(true)
        }
        return true
    }
    
    // MARK: - 监听键盘
    /// 监听键盘弹出
    func keyboardWillShow(_ notification: Notification) {
        let keyBoaryHeight : CGFloat = 252.0
        textCoverView.isHidden = false
        
        let offset : CGFloat = keyBoaryHeight - (UIScreen.main.bounds.height - 64 - remarkOrderNoLabel.frame.maxY)
        
        if(offset > 0) {
            
            //准备动画
            //                        let animationDuration : NSTimeInterval = 0.25
            //                        UIView.beginAnimations("ResizeForKeyboard", context: nil)
            //                        UIView.setAnimationDuration(animationDuration)
            
            //动作
            buttomHeight.constant = buttomViewToButtom + offset
            scrollContentViewHeight.constant = UIScreen.main.bounds.height - 64 + offset
            
            //开启动画
            _ = [UIView.commitAnimations]
            self.view.layoutIfNeeded()
            
            //滑到顶部
            let orgY : CGFloat = myScrollView.contentOffset.y
            myScrollView.setContentOffset(CGPoint(x: 0, y: orgY + offset + 3), animated: true)
        }
    }
    
    // 监听键盘收回
    func keyboardWillHide(_ notification: Notification) {
        
        textCoverView.isHidden = true
        
        //准备动画
        //                let animationDuration : NSTimeInterval = 0.25
        //                UIView.beginAnimations("ResizeForKeyboard", context: nil)
        //                UIView.setAnimationDuration(animationDuration)
        
        //动作
        buttomHeight.constant = 0
        scrollContentViewHeight.constant = UIScreen.main.bounds.height - 64 - buttomViewToButtom
        
        //开启动画
        _ = [UIView.commitAnimations]
        self.view.layoutIfNeeded()
    }
    
    
    // MARK: - 事件
    fileprivate func showUpdataPictureWay () {
        
        let actionSheet : UIActionSheet = UIActionSheet.init(title: "", delegate: self, cancelButtonTitle:"取消", destructiveButtonTitle: nil, otherButtonTitles:"拍照", "相册", "图库")
        actionSheet.show(in: UIApplication.shared.keyWindow!)
    }
    
    
    // MARK: - UIActionSheetDelegate
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        if (buttonIndex == 1) {//相机
            
            if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
                
                NSLog("支持相机")
                makePhoto()
            } else {
                
                let alert : UIAlertView = UIAlertView()
                alert.title = "提示"
                alert.message = "请在设置-->隐私-->相机，中开启本应用的相机访问权限！!"
                alert.delegate = self
                alert.addButton(withTitle: "取消")
                alert.addButton(withTitle: "确定")
                alert.show()
            }
        } else if (buttonIndex == 2) {//相片
            
            if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                
                NSLog("支持相册")
                choosePicture()
            } else{
                
                let alert : UIAlertView = UIAlertView()
                alert.title = "提示"
                alert.message = "请在设置-->隐私-->照片，中开启本应用的相机访问权限！!"
                alert.delegate = self
                alert.addButton(withTitle: "取消")
                alert.addButton(withTitle: "我知道了")
                alert.show()
            }
        } else if (buttonIndex == 3) {//图册
            if(UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)) {
                
                NSLog("支持图库")
                pictureLibrary()
            } else {
                
                let alert : UIAlertView = UIAlertView()
                alert.title = "提示"
                alert.message = "请在设置-->隐私-->照片，中开启本应用的相机访问权限！！"
                alert.delegate = self
                alert.addButton(withTitle: "取消")
                alert.addButton(withTitle: "我知道了")
                alert.show()
            }
        }
    }
    
    
    // MARK: - 照片
    func createData() {
        
        // 初始化pickerController
        pickerController = UIImagePickerController()
        pickerController?.view.backgroundColor = UIColor.groupTableViewBackground
        pickerController?.delegate = self
//        pickerController?.allowsEditing = true
    }
    
    
    // 跳转到imagePicker里
    func makePhoto() {
        
        pickerController?.sourceType = .camera
        self.present(pickerController!, animated: true, completion: nil)
    }
    
    
    
    // 跳转到相册
    func choosePicture() {
        
        pickerController?.sourceType = .savedPhotosAlbum
        self.present(pickerController!, animated: true, completion: nil)
    }
    
    
    // 跳转图库
    func pictureLibrary() {
        
        pickerController?.sourceType = .photoLibrary
        
        self.present(pickerController!, animated: true, completion: nil)
    }
    
    
    
    
    /// 解开注释产生bug，例如触发函数后再点添加图片，会出现奇怪现象
    
    //    func textFieldDidBeginEditing(textField: UITextField) {
    //        let h : CGFloat =  360.0
    //
    //        let offset : CGFloat = h - (UIScreen.mainScreen().bounds.height - CGRectGetMaxY(remarkOrderNoLabel.frame))  //键盘高度400
    //
    //        let animationDuration : NSTimeInterval = 0.30
    //
    //        UIView.beginAnimations("ResizeForKeyboard", context: nil)
    //        UIView.setAnimationDuration(animationDuration)
    //
    //        if(offset > 0) {
    //            self.view.frame = CGRectMake(0.0, -offset, self.view.frame.size.width, self.view.frame.size.height)
    //
    //            [UIView.commitAnimations]
    //        }
    //    }
    //
    //    func textFieldDidEndEditing(textField: UITextField) {
    //        let animationDuration : NSTimeInterval = 0.30
    //        UIView.beginAnimations("ResizeForKeyboard", context: nil)
    //        UIView.setAnimationDuration(animationDuration)
    //        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
    //        [UIView.commitAnimations]
    //    }
}
