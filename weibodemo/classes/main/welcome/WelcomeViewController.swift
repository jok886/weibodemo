//
//  WelcomeViewController.swift
//  weibodemo
//
//  Created by macliu on 2021/1/19.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headIconView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //0. 设置头像
        let profileURL = UserAccountViewMode.shareInstance.account?.avatar_large
        //?? 如果前面有值，前面解包赋值， 可选是nil后面 值赋值
        let url = NSURL(string: profileURL ?? "")
        headIconView.sd_setImage(with: url as URL?, placeholderImage: UIImage(named: "avatar_default_big"), options: .highPriority, context: nil)
        
        //
        iconViewBottomCons.constant = UIScreen.main.bounds.height - 200
        //执行动画
        //usingSpringWithDamping 阻力系数 弹动效果越不明显 0-1
        //initialSpringVelocity 初始化速度
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: []) {
            self.view.layoutIfNeeded()
        } completion: { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            
        }

        
    }

    // MARK: -



}
