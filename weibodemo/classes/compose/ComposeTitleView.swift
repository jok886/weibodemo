//
//  ComposeTitleView.swift
//  weibodemo
//
//  Created by macliu on 2021/1/21.
//

import UIKit
import SnapKit

class ComposeTitleView: UIView {

    //
    private lazy var titleLabel : UILabel = UILabel()
    private lazy var screenNameLabel : UILabel = UILabel()
    
    
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ComposeTitleView {
    private func setupUI () {
        //子控件添加到view
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        //
        //2. 设置frame
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp_centerX)
            make.top.equalTo(titleLabel.snp_bottom).offset(3)
        }
        //设置空间属性
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        
        screenNameLabel.textColor = UIColor.lightGray
        //
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewMode.shareInstance.account?.screen_name
        
    }
}
