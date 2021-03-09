//
//  VisitorView.swift
//  weibodemo
//
//  Created by macliu on 2021/1/18.
//

import UIKit
import SDWebImage

class VisitorView: UIView {

 
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }
    
    // MARK:- 控件属性
    
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    
    func addRotation() {
        // 创建旋转动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")

        // 设置动画属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 4 //转1圈的时间
        rotationAnim.isRemovedOnCompletion = false //切换之后动画会移除

        // 将动画添加到layer中
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
    
    
    // MARK:- 设置内容的函数
    func setupVisitorViewInfo(iconName : String, tipString : String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = tipString
        rotationView.isHidden = true
        
      //  iconView.sd_setImage(with: <#T##URL?#>, placeholderImage: <#T##UIImage?#>, options: <#T##SDWebImageOptions#>, context: <#T##[SDWebImageContextOption : Any]?#>)
   
    }
    
}
