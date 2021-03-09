//
//  UITextView-Extension.swift
//  nettool
//
//  Created by macliu on 2021/1/22.
//

import UIKit

extension UITextView {
    
    //
    func getEmotionString() -> String {
        let attrMStr = NSMutableAttributedString(attributedString: self.attributedText)
        //遍历属性字符串
        let range = NSRange(location: 0, length: attrMStr.length)
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict[NSAttributedString.Key(rawValue: "NSAttachment")] as? EmotionAttachment {
                
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        //3.获取字符串
        return attrMStr.string
    }
    
    //
    func insertEmotion(emotion : Emotion){
        //1. 空白表情
        if emotion.isEmpty {
            return
        }
        //2. 删除按钮
        if emotion.isRemove {
            //
            deleteBackward()
            return
        }
        //3. emoji表情
        if emotion.emojiCode != nil {
            //3.1 获取光标位置
            let textRange = selectedTextRange!
            //3.2
            replace(textRange, withText: emotion.emojiCode!)
            
            return
        }
        //4.普通标签 图文混排
        //4.1创建属性字符串
        let attachment = EmotionAttachment()
        attachment.chs = emotion.chs
        attachment.image = UIImage(contentsOfFile: emotion.pngPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font
                                    .lineHeight, height: font
                                    .lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        //4.2
        let attrMStr = NSMutableAttributedString(attributedString: self.attributedText)
        
        let range = selectedRange
        //4.3替换进去
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        //显示属性字符串
        self.attributedText = attrMStr
        //文字大小重置
        self.font = font
        //光标设置回原来 +1
        self.selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
