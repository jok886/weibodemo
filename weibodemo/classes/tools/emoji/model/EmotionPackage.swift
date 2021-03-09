//
//  EmotionPackage.swift
//  nettool
//
//  Created by macliu on 2021/1/21.
//

import UIKit

class EmotionPackage: NSObject {
    var emotions : [Emotion] = [Emotion]()
    init(id : String) {
        super.init()
        
        if id == "" {
            addEmptyEmotion(isRecenty: true)
            return
        }
        //2.根据ID拼接info.plist 路径
        let plistPath = Bundle.main.path(forResource: "\(id)/info.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        //3.根据路径读取
        let array = NSArray(contentsOfFile: plistPath)! as! [[String : String]]
        //4遍历
        var index = 0
        
        for var dict in array {
          
            
            if let png = dict["png"] {
              dict["png"]  =  id + "/" + png
            }
            emotions.append(Emotion(dict: dict))
            index += 1
            if index == 20  {
                //添加删除表情
                emotions.append(Emotion(isRemove: true))
                index = 0
            }
        }
        //5.添加空包表情
        self.addEmptyEmotion(isRecenty: false)
        
    }
    private func addEmptyEmotion(isRecenty : Bool) {
        let count = emotions.count % 21
        if count == 0  && !isRecenty{
            return
        }
        for _ in count..<20 {
            emotions.append(Emotion(isEmpty: true))
        }
        emotions.append(Emotion(isRemove: true))
    }
}
