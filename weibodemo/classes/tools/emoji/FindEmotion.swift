//
//  FindEmotion.swift
//  nettool
//
//  Created by macliu on 2021/1/22.
//

import UIKit

class FindEmotion: NSObject {
    
    //
    static let shareInstance : FindEmotion = FindEmotion()
    
    //
    private lazy var manage : EmotionManager = EmotionManager()
    
    //
    func findAttrString(statusText : String?,font : UIFont) -> NSMutableAttributedString? {
        
        //
        guard let statusText = statusText  else {
            return nil
        }
        
        
        //正则表达式
 
        //1.创建正则规则
        let pattern = "\\[.*?\\]"//"[a-z][0-9]"//"abc"
        //2.创建对象  try try? try!
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        //3.匹配字符串
        let results =  regex.matches(in: statusText, options: [], range: NSRange(location: 0, length: statusText.count ))
        //4.遍历数组获取结果
        //
        var attrMStr = NSMutableAttributedString(string: statusText)
        
        
      //  for i in (0...results.count).reversed()
        for i in stride(from:  results.count - 1, through: 0, by: -1) {
            let result = results[i]
            //4.1
            let chs = (statusText as NSString).substring(with: result.range)
            //4.2 根据chs查找图片路径
            guard let pngPath = self.findPngPath(chs: chs)  else {
                return nil
            }
            //4.3 创建属性字符串
            let attachment = NSTextAttachment()
         //   attachment.chs = emotion.chs
            attachment.image = UIImage(contentsOfFile: pngPath)
            let font = font
            attachment.bounds = CGRect(x: 0, y: -4, width: font
                                        .lineHeight, height: font
                                        .lineHeight)
            let attrImageStr = NSAttributedString(attachment: attachment)
            //4.4 将属性字符串替换到来源文字位置
            attrMStr.replaceCharacters(in: result.range, with: attrImageStr)
           
        }
        
        return attrMStr
    }
    private func findPngPath(chs : String) -> String? {
        
        for package in manage.packages {
            for emotion in package.emotions {
                if emotion.chs == chs {
                    return emotion.pngPath
                }
            }
        }
        return nil
    }
    
}
