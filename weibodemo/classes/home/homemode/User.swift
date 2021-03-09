//
//  User.swift
//  weibodemo
//
//  Created by macliu on 2021/1/20.
//

import UIKit

@objcMembers
class User: NSObject {
    // MARK:- 属性
    var profile_image_url : String?  //用户头像
    var screen_name : String?     //昵称
    var verified_type : Int = -1  //认证类型
   
    var mbrank : Int  = 0            //会员等级
  
    
    
    init(dict : [String : AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        
    }
    override class func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
