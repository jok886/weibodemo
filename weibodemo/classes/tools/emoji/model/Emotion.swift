//
//  Emotion.swift
//  nettool
//
//  Created by macliu on 2021/1/21.
//

import UIKit

@objcMembers
class Emotion: NSObject {

    // MARK: - 变量
    var code : String? {// emoji的code
        didSet {
            guard let code = code else {
                return
            }
            // 1.创建扫描
            let scanner = Scanner(string: code)
            
            // 2.定义变量
            var value : UInt32 = 0
            scanner.scanHexInt32(&value)
            
            // 3.将value转成字符
            let c = Character(UnicodeScalar(value)!)
            
            // 4.将字符转成字符串
            emojiCode = String(c)
            
        }
    }
    var png : String?  {//普通表情的图片
        didSet {
            guard let png = png else {
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var chs : String?  //普通表情对应的文字
    
    // MARK: - 数据处理
    var pngPath : String?
    var emojiCode : String?
    var isRemove : Bool = false    /// 删除按钮
    var isEmpty : Bool = false  /// 添加空白表情
    
    // MARK: - 构造
    init(dict : [String : String]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override class func setValue(_ value: Any?, forUndefinedKey key: String) {
        //
    }
    init(isRemove : Bool) {
        self.isRemove = isRemove
    }
    init(isEmpty : Bool) {
        self.isEmpty = isEmpty
    }
    override var description: String {
        return dictionaryWithValues(forKeys: ["emojiCode","pngPath","chs"]).description
    }
}
