//
//  ProgressView.swift
//  weibodemo
//
//  Created by macliu on 2021/1/23.
//

import UIKit

class ProgressView: UIView {

    // MARK: - 属性
    var progress : CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - 函数
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5 )
        let radius = rect.width * 0.5 - 3
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2 * M_PI) * progress + startAngle
        
        //创建贝塞尔
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        //绘制到中心的线
        path.addLine(to: center)
        path.close()
        //设置颜色
        UIColor(white: 1.0, alpha: 0.4).setFill()
        //绘制
        path.fill()
        
        
        
    }

}
