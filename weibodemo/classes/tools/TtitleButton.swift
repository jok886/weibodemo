//
//  TtitleButton.swift
//  weibodemo
//
//  Created by macliu on 2021/1/18.
//

import UIKit

class TtitleButton: UIButton{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    //swift:重写控件init方法，必须重写init?(coder: NSCoder)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       // var rect = titleLabel!.frame
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 8
    }
    
}
