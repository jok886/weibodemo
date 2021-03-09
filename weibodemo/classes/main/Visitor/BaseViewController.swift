//
//  BaseViewController.swift
//  weibodemo
//
//  Created by macliu on 2021/1/15.
//

import UIKit

class BaseViewController: UITableViewController {
    // MARK: -懒加载属性
    lazy var visitorView : VisitorView = VisitorView.visitorView()
    // MARK: -定义变量
    var isLogin : Bool = UserAccountViewMode.shareInstance.isLogin

    // MARK: -系统回调函数
    override func loadView() {

        isLogin ? super.loadView() : setupvistorView()
    }
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItems()
     
    }


}
// MARK: -扩展
extension BaseViewController {
    private func setupvistorView() {
      //  visitorView.backgroundColor = UIColor.red
        view = visitorView
        
        visitorView.loginBtn.addTarget(self, action:  #selector(self.loginBtnClick), for: .touchUpInside)
        visitorView.registerBtn.addTarget(self, action:  #selector(self.registerBtnClick), for: .touchUpInside)
    }
    
    ///设置导航栏得到左右item
    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(self.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(self.loginBtnClick))
    }
}

// MARK: -事件监听
extension BaseViewController {
   @objc private func registerBtnClick()  {
        print("zhuce")
    }
    @objc private func loginBtnClick() {
        print("denglu")
        
        let vc =  WBOAuthViewController() //OAuthViewController()
        //
        let nacvc = UINavigationController(rootViewController: vc);
        nacvc.modalPresentationStyle = .fullScreen
        //
        present(nacvc, animated: true, completion: nil)
        
        
     }
}
