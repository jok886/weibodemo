//
//  UIBarButtonItem-Extersion.swift
//  weibodemo
//
//  Created by macliu on 2021/1/18.
//

import UIKit

extension UIBarButtonItem {
    
   /* convenience init(imageName : String) {
        self.init()
        
        //
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        customView = btn
        
    }*/
    convenience init(imageName : String) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.init(customView : btn)
        
    }
    
}
