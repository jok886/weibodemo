//
//  UserAccountTool.swift
//  weibodemo
//
//  Created by macliu on 2021/1/19.
//

import UIKit
//



//

class UserAccountViewMode {
    // MARK: -单列
    static let shareInstance : UserAccountViewMode = UserAccountViewMode()
    
    var account : UserAccount?
    //计算属性
    var accountPath : String {
        //1.从沙盒归档读取
        //1.1沙盒
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).appendingPathComponent("account.plist")
        
     
    }
    var isLogin : Bool {
        if account == nil {
            return false
        }
        guard let expirDate =  account?.expires_date else{
            return false
        }
        return expirDate.compare(NSDate() as Date) == ComparisonResult.orderedDescending
    }
    
    // MARK: -init
    init () {
        //
        //1.2读取
         account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as? UserAccount
        
    }

  
}
