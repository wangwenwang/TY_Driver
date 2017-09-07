//
//  AutographUIView.swift
//  newDriver
//
//  Created by 凯东源 on 16/7/1.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class AutographUIView: UIView {
    
    /// 线条颜色
    var color = UIColor.black
    /// 线条宽度
    var lineWidth: Float = 1.0
    /// 保存已有的线条
    var allLine: [Dictionary<String, AnyObject>] = []
    /// 保存被撤销的线条
    fileprivate var cancelLine: [Dictionary<String, AnyObject>] = []
    /// 贝赛尔曲线
    fileprivate var bezier = UIBezierPath()
    
    /// 清除用户绘制的签名
    func backImage() {
        if allLine.isEmpty == false { // 如果数组不为空才执行
            cancelLine.append(allLine.last!) // 入栈
            allLine.removeAll() // 出栈
            setNeedsDisplay() // 重绘界面
        }
    }
    
    // MARK:- touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bezier = UIBezierPath() // 新建贝塞尔曲线
        let point = touches.first!.location(in: self) // 获取触摸的点
        bezier.move(to: point) // 把刚触摸的点设置为bezier的起点
        var tmpDic = Dictionary<String, AnyObject>()
        tmpDic["color"] = color
        tmpDic["lineWidth"] = lineWidth as AnyObject?
        tmpDic["line"] = bezier
        allLine.append(tmpDic) // 把线存入数组中
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self) // 获取触摸的点
        bezier.addLine(to: point) // 把移动的坐标存到贝赛尔曲线中
        setNeedsDisplay() // 重绘界面
    }
    
    // MARK:- drawRect
    override func draw(_ rect: CGRect) {
        drawDate()
        drawAutograph()
    }
    
    /// 绘制时间
    fileprivate func drawDate () {
        let s: NSString = DateUtils.getCurrentDate() as NSString
        
        let fieldColor: UIColor = UIColor.darkGray
        
        let fieldFont = UIFont(name: "Helvetica Neue", size: 14)
        
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0
        
        let skew = 0.1
        
        let attributes = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!
        ] as [String : Any]
        
        let textSize = NSString(string: s).size(attributes: attributes)
        
        let x: CGFloat = self.frame.width - textSize.width - 5
        let y: CGFloat = self.frame.height - textSize.height
        let width: CGFloat = self.frame.width
        let height: CGFloat = self.frame.height
        
        s.draw(in: CGRect(x: x, y: y, width: width, height: height), withAttributes: attributes)
    }
    
    
    /// 绘制签名
    fileprivate func drawAutograph () {
        for i in 0..<allLine.count {
            let tmpDic = allLine[i]
            let tmpColor = tmpDic["color"] as! UIColor
            let tmpWidth = tmpDic["lineWidth"] as! CGFloat
            let tmpPath = tmpDic["line"] as! UIBezierPath
            tmpColor.setStroke()
            tmpPath.lineWidth = tmpWidth
            tmpPath.stroke()
        }
    }

}



































