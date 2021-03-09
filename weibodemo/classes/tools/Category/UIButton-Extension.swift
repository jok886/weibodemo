//
//  UIButton-Extension.swift
//  weibodemo
//
//  Created by macliu on 2021/1/15.
//

import UIKit

extension UIButton {
    //swift 类方法  以class +
  /*  class func createButton(imageName : String ,bgimageName : String) -> UIButton {
       let btn = UIButton()
        //
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: bgimageName), for: .normal)
        btn.setBackgroundImage(UIImage(named: bgimageName + "_highlighted"), for: .highlighted)
        
        btn.sizeToFit()
        return btn
    }*/
    //便利，便利构造函数 系统类构造扩充
    /*
     1.通常都是写在extension中
     2.通常都是init前面加
     3.需要明确调用self.init()
     
     */
    convenience init(imageName : String ,bgimageName : String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgimageName), for: .normal)
        setBackgroundImage(UIImage(named: bgimageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(bgColor : UIColor,fontSize : CGFloat,title : String) {
        self.init()
        
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
    }
    
    
}
