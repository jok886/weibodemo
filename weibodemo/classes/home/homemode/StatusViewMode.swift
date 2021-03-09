//
//  StatusViewMode.swift
//  weibodemo
//
//  Created by macliu on 2021/1/20.
//

import UIKit

class StatusViewMode: NSObject {
    // MARK:- 定义属性
    var status : Status?
    
    var cellHeight : CGFloat = 0
    
    // MARK:- 处理属性
    var sourceText : String?   // 来源
    var createatText : String? //时间
    var verifiedImage : UIImage?  //认证图标
    var vipImage : UIImage?       //会员等级
    var profileURL : NSURL?    //处理头像url
    var picURLs : [NSURL] = [NSURL]()  //配图
    
    
    
    // MARK:- 自定义构造
    init(status : Status) {
        self.status = status
        
        //1.来源
        //1 nil校验 或 “”
      
        if let source = status.source , status.source != "" {
            //2 获取起始位置
             //
             let startIndex = (source as NSString).range(of: ">").location + 1
             let length = (source as NSString).range(of: "</").location - startIndex
             //
             sourceText = (source as NSString).substring(with: NSRange(location: startIndex, length: length))
        }
     
   
        //时间
        //
        if let create_at = status.create_at,  status.create_at != ""  {
            createatText = NSDate.createDateString(createStr: create_at)
        }
        //2.处理认证等级
        let verified_type = status.user?.verified_type ?? -1
        switch verified_type {
            case 0:
                verifiedImage = UIImage(named: "avatar_vip")
            case 2,3,5:
                verifiedImage = UIImage(named: "avatar_enterprise_vip")
            case 220:
                verifiedImage = UIImage(named: "avatar_grassroot")
            default:
                verifiedImage = nil
        }
        //会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
            
        }
        
        //5
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = NSURL(string: profileURLString)
        //6 . 配图处理
        let picURLDicts = status.pic_urls!.count != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picURLDicts = picURLDicts {
            for picURLDict in picURLDicts {
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                     continue
                }
                picURLs.append(NSURL(string: picURLString)!)
            }
        }
        
        
    }
}
