//
//  UserAccount.swift
//  weibodemo
//
//  Created by macliu on 2021/1/19.
//

import UIKit

@objcMembers
class UserAccount: NSObject,NSCoding {
   //
    //授权
    @objc var access_token : String?
    //过期时间
    @objc var expires_in   : Double = 0.0 {
        didSet {
            //+ 8 * 60 * 60
            expires_date = NSDate(timeIntervalSinceNow: expires_in )
        }
    }
    //用户ID
    @objc var uid : String?
    //
    @objc var expires_date : NSDate?
    //昵称
     var screen_name : String?
    //头像地址
     var avatar_large : String?
    
    
    override init() {
        
    }
    // MATK:-- 构造
    init(dict: [String: Any]) {
            super.init()
            setValuesForKeys(dict)
    }
        
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
            
    }
    
    
    
    override var description: String {
        return dictionaryWithValues(forKeys: ["access_token","expires_date","uid","screen_name","avatar_large"]).description
    }
    
    //解档
    required init?(coder: NSCoder) {
        access_token = coder.decodeObject(forKey: "access_token") as? String
        expires_date = coder.decodeObject(forKey: "expires_date") as? NSDate
        uid          = coder.decodeObject(forKey: "uid") as? String
        screen_name  = coder.decodeObject(forKey: "screen_name") as? String
        avatar_large = coder.decodeObject(forKey: "avatar_large") as? String
  

    }
    //归档
    func encode(with coder: NSCoder) {
        coder.encode(access_token,forKey: "access_token")
        coder.encode(expires_date,forKey: "expires_date")
        coder.encode(uid,forKey: "uid")
        coder.encode(screen_name,forKey: "screen_name")
        coder.encode(avatar_large,forKey: "avatar_large")
    }
}
