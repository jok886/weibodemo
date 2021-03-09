//
//  NSDate-Extension.swift
//  weibodemo
//
//  Created by macliu on 2021/1/19.
//

import Foundation

extension NSDate {
    //
    class  func createDateString(createStr : String) -> String {
        //
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale(identifier: "en")
        
        //
        guard let createDate = fmt.date(from: createStr) else {
            return ""
        }
        //
        print(createDate)
        //3.当前日期
        let nowDate = Date()
        
        //
       let interval = Int( nowDate.timeIntervalSince(createDate))
       
        //对时间间隔处理
        //1分钟
        if interval < 60 {
           // print("刚刚")
            return "刚刚"
        }
        //59分
        if interval < 60 * 60 {
           // print("\(interval / 60 )分钟前")
            return "\(interval / 60 )分钟前"
        }
        //11小时
        if interval < 60 * 60 * 24 {
          //  print("\(interval / 60 / 60 )小时前")
            return "\(interval / 60 / 60 )小时前"
        }
        //昨天
       let calendar =  NSCalendar.current
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timestr =  fmt.string(from: createDate)
          
            return timestr
        }
        //月
        //[Calendar.Component.year,Calendar.Component.month,Calendar.Component.day]
        let cmps = calendar.dateComponents([Calendar.Component.year], from: createDate, to: nowDate)
        if cmps.year! < 1  {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
       //超过一年  2020-10-01 10:10
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: createDate)
        return timeStr
    }
}
