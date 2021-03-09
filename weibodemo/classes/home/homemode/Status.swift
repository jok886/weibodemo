//
//  Status.swift
//  weibodemo
//
//  Created by macliu on 2021/1/19.
//https://github.com/LiHe0308/SwiftDemo_WeiBo/

import UIKit

@objcMembers
class Status: NSObject {
    // MARK:- 属性
    @objc var create_at : String?   //创建时间
       
    @objc var source : String?      //微博来源
     
    @objc var text : String?         //正文
    @objc var mid : Int = 0         //ID
    
    var user : User?
    var pic_urls : [[String : String]]?  //配图
    var retweeted_status : Status?  //转发微博
    
    
    // MARK:- 自定义构造
  
    
    init(dict: [String: Any]) {
            super.init()
            setValuesForKeys(dict)
        if  let userDict = dict["user"] as? [String : AnyObject] {
            user = User(dict: userDict)
        }
        //2. 转发微博字典转成转发模型
        if let retweeted_Dict = dict["retweeted_status"] as? [String : AnyObject]  {
            retweeted_status = Status(dict: retweeted_Dict)
            
        }
        
    }
        
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
            
    }
    
}
