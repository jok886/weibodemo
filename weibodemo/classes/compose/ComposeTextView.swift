//
//  ComposeTextView.swift
//  weibodemo
//
//  Created by macliu on 2021/1/21.
//

import UIKit
import SnapKit

class ComposeTextView: UITextView {
    // MARK: -属性
    lazy var placeHolderLabel : UILabel = UILabel()
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
}
// MARK: -UI
extension ComposeTextView {
    private func setupUI() {
        //添加
        addSubview(placeHolderLabel)
        //约束
        placeHolderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        //设置属性
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = UIFont.systemFont(ofSize: 14)
        //
        placeHolderLabel.text = "分享新鲜事....."
        
        //5 设置内容内边距
        textContainerInset = UIEdgeInsets(top: 6, left: 7, bottom: 0, right: 7)
        
    }
}
