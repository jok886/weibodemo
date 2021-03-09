//
//  WBOAuthViewController.swift
//  weibodemo
//
//  Created by macliu on 2021/1/23.
//

import UIKit
import SVProgressHUD

class WBOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        view = webView
        
        view.backgroundColor = UIColor.white
        //取消页面滚动
        webView.scrollView.isScrollEnabled = false
        //设置代理
        webView.delegate = self
        
        // 设置导航栏
        title = "登陆新浪微博"
        //导航栏按钮
      //  navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", target: self, action: #selector(close), isBack: true)
        
     //   navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充", target: self, action: #selector(autoFill))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain,target: self,action: "close")
        //2设置右
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain,target: self,action: "autoFill")
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        //1> 确定要访问的对象
        guard let url = URL(string: urlString) else {
            return
        }
        //2> 建立请求
        let request = URLRequest(url:url)
        
        //3> 加载请求
        webView.loadRequest(request)
        
        
    }
    //MARK: - 监听方法
    
    @objc private func close(){
        
        SVProgressHUD.dismiss()
        
        dismiss(animated: true, completion: nil)
    }
    
    /// 自动填充用户名和密码
    @objc private func autoFill() {
        
        //准备js
        let js = "document.getElementById('userId').value = '13532265108';" + "document.getElementById('passwd').value = 'Kk2615391';"
        
        
        
        //让webview执行 js
        webView.stringByEvaluatingJavaScript(from: js)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension OAuthViewController {
     
    
    
}



extension WBOAuthViewController : UIWebViewDelegate {
    /// webView将要加载请求
    /// - Parameters:
    ///   - webView: webView
    ///   - request: j要加载的请求
    ///   - navigationType: 导航类型
    ///
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        if request.url?.absoluteString.hasPrefix(redirect_uri) == false {
            return true
        }
        
        print("加载请求 ---- \(String(describing: request.url?.absoluteString))")
        print("加载请求 ---- \(String(describing: request.url?.query))")
        
        if request.url?.query?.hasPrefix("code=") == false {
            print("取消授权")
            close()
            return false
        }
        
        let code = String(request.url?.query?["code=".endIndex...] ?? "")
        print("获取授权码\(code)")
        
        //4> 使用授权吗 获取AccessToken
       loadAccessToken(code: code)
        
        
      /*  WBNetworkManager.shared().getAccessToken(code: code) { (isSuccess) in
            
            if !isSuccess {
                SVProgressHUD.showInfo(withStatus: "登陆失败")
            }else {
                SVProgressHUD.showInfo(withStatus: "登陆成功")
                
                //1> 通过通知跳转 发送登陆成功消息
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WBUserLoginSuccessNotification), object: nil)
                
                
                self.close()
                
            }
        }*/
        
        
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func loadAccessToken(code : String) {
       NetWorkTool.shareIntance.loadAccessToken(code: code) { (result, error) in
           //
           if error != nil {
               print(error)
               return
           }
           
       /*    {
                  "access_token": "ACCESS_TOKEN",
                  "expires_in": 157679999,  //access_token的生命周期，单位是秒数
                  "remind_in":"798114",
                  "uid":"12341234"  //授权用户的UID，本字段只是为了方便开发者
            }
           */
           
           //拿到结果
           guard let accountDict = result else {
               print("no data")
               return
           }
           //
           let account = UserAccount(dict: result! as [String : AnyObject])
           //请求用户信息
           self.loadUserInfo(account: account)
           
       }
   }
   //
   private func loadUserInfo(account : UserAccount) {
       //1
       guard let accesstoken = account.access_token   else {
           return
       }
       
       //2
       guard let uid = account.uid   else {
           return
       }
       //3
       NetWorkTool.shareIntance.loadUserInfo(access_token: accesstoken, uid: uid) { (result, error) in
           if error != nil {
               //出错
               print(error)
               return
           }
           
           //拿到用户信息
           //screen_name    string    用户昵称
          // profile_image_url    string    用户头像地址（中图），50×50像素
          // avatar_large    string    用户头像地址（大图），180×180像素
         //  avatar_hd    string    用户头像地址（高清），高清头像原图
           guard let userInfoDict = result else {
               return
           }
           
           //取出昵称和头像地址
           account.screen_name =  userInfoDict["screen_name"] as? String
           account.avatar_large = userInfoDict["avatar_large"] as? String
           
           //4. account 对象保存
           //4.1沙盒
         //  var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
         //  accountPath = (accountPath as NSString).appendingPathComponent("account.plist")
         //  print(accountPath)
           //4.2保存
           NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountViewMode.shareInstance.accountPath)
           //4.3
           UserAccountViewMode.shareInstance.account = account;
           
           
           
           //5 退出当前控制器
           self.dismiss(animated: true) {
               UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
           }
           
           //5. 显示欢迎界面
         
           
           
       }
   }
    
    
}
