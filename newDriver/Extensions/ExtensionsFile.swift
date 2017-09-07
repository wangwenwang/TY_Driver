//
//  ExtensionsFile.swift
//  newDriver
//
//  Created by 凯东源 on 16/7/1.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ExtensionsFile: UIView {

}

extension UIImage {

    /**
    *  对指定图片进行拉伸
    */
    func resizableImage(_ image: UIImage, scaleSize: CGFloat) -> UIImage {
        
        var normal = image
        let imageWidth = normal.size.width * scaleSize
        let imageHeight = normal.size.height * scaleSize
        normal = self.resizableImage(withCapInsets: UIEdgeInsetsMake(imageHeight, imageWidth, imageHeight, imageWidth))
        
        return normal
    }
    
    /**
     *  压缩上传图片到指定字节
     *
     *  image:     压缩的图片
     *
     *  maxLength: 压缩后最大字节大小
     *
     *  return 压缩后图片的二进制
     */
    func compressImage(_ image: UIImage, maxLength: Int, maxWidthOrHeight: CGFloat) -> Data? {
        
        let newSize = self.scaleImage(image, imageLength: maxWidthOrHeight)
        let newImage = self.resizeImage(image, newSize: newSize)
        
        var compress:CGFloat = 0.9
        var data = UIImageJPEGRepresentation(newImage, compress)
        
        while data?.count > maxLength && compress > 0.01 {
            data = UIImageJPEGRepresentation(newImage, compress)
            compress -= 0.02
        }
        
        return data
    }
    
    /**
     *  通过指定图片最长边，获得等比例的图片size
     *
     *  image:       原始图片
     *
     *  imageLength: 图片允许的最长宽度（高度）
     *
     *  return 获得等比例的size
     */
    func  scaleImage(_ image: UIImage, imageLength: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = image.size.width
        var newHeight:CGFloat = image.size.height
        let width = image.size.width
        let height = image.size.height
        
        if (width > imageLength || height > imageLength){
            
            if (width > height) {
                
                newWidth = imageLength;
                newHeight = newWidth * height / width;
                
            }else if(height > width){
                
                newHeight = imageLength;
                newWidth = newHeight * width / height;
                
            }else{
                
                newWidth = imageLength;
                newHeight = imageLength;
            }
            
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    
    /**
     *  获得指定size的图片
     *
     *  image:   原始图片
     *
     *  newSize: 指定的size
     *
     *  return 调整后的图片
     */
    func resizeImage(_ image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}




extension UIImage{
    
    //水印位置枚举
    enum WaterMarkCorner{
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    //添加水印方法
    func waterMarkedImage(_ waterMarkText:String, corner:WaterMarkCorner = .bottomRight,
                          margin:CGPoint = CGPoint(x: 20, y: 20),
                          waterMarkTextColor:UIColor = UIColor.white,
                          waterMarkTextFont:UIFont = UIFont.systemFont(ofSize: 20),
                          backgroundColor:UIColor = UIColor.clear) -> UIImage{
        
        let textAttributes = [NSForegroundColorAttributeName:waterMarkTextColor,
                              NSFontAttributeName:waterMarkTextFont,
                              NSBackgroundColorAttributeName:backgroundColor]
        let textSize = NSString(string: waterMarkText).size(attributes: textAttributes)
        var textFrame = CGRect(x: 0, y: 0, width: textSize.width, height: textSize.height)
        
        let imageSize = self.size
        switch corner{
        case .topLeft:
            textFrame.origin = margin
        case .topRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
        case .bottomLeft:
            textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
        case .bottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x,
                                       y: imageSize.height - textSize.height - margin.y)
        }
        
        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        NSString(string: waterMarkText).draw(in: textFrame, withAttributes: textAttributes)
        
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return waterMarkedImage!
    }
}

























