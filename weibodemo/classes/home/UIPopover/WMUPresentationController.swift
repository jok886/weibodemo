//
//  WMUPresentationController.swift
//  weibodemo
//
//  Created by macliu on 2021/1/18.
//

import UIKit

class WMUPresentationController: UIPresentationController {
    
    var presentedFrame : CGRect = .zero
    
    private lazy var coverView : UIView = UIView()
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        //设置弹出尺寸
        presentedView?.frame = presentedFrame //
        
        //添加蒙版
        setupCoverView()
    }
}

extension WMUPresentationController {
    private func setupCoverView() {
        //添加蒙版
        containerView?.insertSubview(coverView, at: 0)

        //
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        coverView.frame = containerView!.bounds
        
        //点击事件 手势
        let tapGes = UITapGestureRecognizer(target: self, action: "coverViewClick")
        coverView.addGestureRecognizer(tapGes)
        
        
        
    }
}

extension WMUPresentationController {
    @objc private func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
