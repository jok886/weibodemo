//
//  OAuthViewController.swift
//  weibodemo
//
//  Created by macliu on 2021/1/18.
//

import UIKit
import WebKit
import SVProgressHUD

/** 微博授权控制器 -> 就是登录控制器
 - OAuth授权
    - open auth 开放的授权
 - 使用微博OAuth授权,  做的是自己的项目, 显示的数据是新浪微博提供的数据
 - 如何才可以获取到新浪微博的数据
    - 注册一个新浪微博账号
    - 登录http://www.open.weibo.com (新浪微博开发者中心)
    - 成为开发者
        - 个人版
        - 企业版 -> 公司
    - 在自己的app中使用新浪微博提供的数据
    - 添加测试账号(在当前app 没有上架之前只有测试账号才可以拿到新浪微博的数据)  上架以后 只要使用当前app的使用者均可以访问新浪微博的数据
    - 登录开发者中心,  完善个人信息, 注册一个应用(微链接 -> 移动应用 -> 立即接入 ->验证成功后,重新打开, 新建应用)
    - 选择应用:
        - 应用信息 -> 基本信息 ->就会返回一些信息
             - APPKEY
             - APPSECRECT
        - 为我们获取code (授权码) token(访问令牌, 有实效性能)
        - 高级信息 -> 手动去设置回调链接
        - 测试信息 -> 输入微博用户 ->添加测试用户(之后的登录注册, 获取数据都是使用该测试账号)
    - 在我们的app中加载webView (微博授权登录界面)
    - 确认授权
    - 获取code
    - 通过code 获取 token
    - 以后请求新浪微博数据 均是通过token 获取到当前账号的微博数据
 */
//let REDIRECT_URI = "https://www.baidu.com"  // 重定向的地址 -> 设置的回调页, 需要和微博开放平台的高级信息中设置的相同



class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //
        setupNavi()
        //创建网址
        //    let url = NSURL(string: "http://www.baidu.com")
            //创建请求
         //   let request = NSURLRequest(url: url! as URL)
        
        webView.navigationDelegate = self
      //  webView.uiDelegate = self
        
        // 去掉WKWebView自带的 工具栏
        webView.hack_removeInputAccessory()
        
        //加载请求
      //  webView.load(request as URLRequest)
        //加载页面
        loadPage()
        
    }




}

//MARK:--设置UI
extension OAuthViewController {
    private func setupNavi() {
        //1 设置左
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain,target: self,action: "closeItemClick")
        //2设置右
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain,target: self,action: "fillItemClick")
        
        //3设置标题
        title = "登录页面"
    }
    private func loadPage() {
        //获取url
     //   let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        
        //nsurl
        guard let url = NSURL(string: urlString) else {
            return
        }
        //
        let request = NSURLRequest(url: url as URL)
        
        //
        webView.load(request as URLRequest)
        
        
        
    }
}
//MARK:--事件
extension OAuthViewController {
    @objc private func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func fillItemClick() {
        //1.书写js代码
   
        let jsCode = "document.getElementById('userId').value='18513041937';document.getElementById('passwd').value='ABC123456';"
        //2.
        webView.evaluateJavaScript(jsCode, completionHandler:{ (result : Any?, error : Error?) in
            
        })
    }
}


extension OAuthViewController : WKUIDelegate {
  /*  func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?{
        
    }*/
     
   // (2)iOS9.0中新加入的,处理WKWebView关闭的时间
    func webViewDidClose(webView: WKWebView){
        
    }
     
   // (3)处理网页js中的提示框,若不使用该方法,则提示框无效
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void){
        
    }
     
   // (4)处理网页js中的确认框,若不使用该方法,则确认框无效
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void){
        
    }
     
   // (5)处理网页js中的文本输入
    func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String?) -> Void){
        
    }
}
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
extension OAuthViewController : WKNavigationDelegate {
    //(1)决定网页能否被允许跳转
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void){
        
    }
     
   // (2)处理网页开始加载
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        SVProgressHUD.show()
    }
     
  //  (3)处理网页加载失败
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError){
        SVProgressHUD.dismiss()
    }
     
   // (4)处理网页内容开始返回
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!){
        
    }
     
   // (5)处理网页加载完成
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!){
        SVProgressHUD.dismiss()
    }
     
   // (6)处理网页返回内容时发生的失败
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError){
        
    }
     
   // (7)处理网页进程终止
    func webViewWebContentProcessDidTerminate(webView: WKWebView){
        
    }
    
    // 在收到响应后，决定是否跳转 -> 默认允许
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            //允许跳转
            decisionHandler(.allow)
            //不允许跳转
    //        decisionHandler(.cancel)
    }
    // 在发送请求之前，决定是否跳转 -> 默认允许
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
            
        
        /**打印结果   --> 目标: 获取code值
         Optional("https://api.weibo.com/oauth2/authorize?client_id=223130765&redirect_uri=http://www.baidu.com#")
         Optional("https://api.weibo.com/oauth2/authorize")
         Optional("https://api.weibo.com/oauth2/authorize#")
         Optional("https://api.weibo.com/oauth2/authorize")
         Optional("https://www.baidu.com/?code=4d72ded762a76b07b83d154e14fe575f")   --> 就是这条能得到code
         */
        
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow, preferences)
            return
        }
        let urlString = url.absoluteString
        
        guard urlString.contains("code=") else {
            decisionHandler(.allow, preferences)
            return
        }
        let code = urlString.components(separatedBy: "code=").last!
        print("获取到的code: \(code)")
        
        //5. 请求access_token
        loadAccessToken(code: code)
        
        // 已经拿到code了. 就不需要webView继续向下进行操作了
        decisionHandler(.cancel, preferences)
        return
        
        /*
        
        let urlString2 = navigationAction.request.url?.absoluteString
            print(urlString2)
            /**打印结果   --> 目标: 获取code值
             Optional("https://api.weibo.com/oauth2/authorize?client_id=223130765&redirect_uri=http://www.baidu.com#")
             Optional("https://api.weibo.com/oauth2/authorize")
             Optional("https://api.weibo.com/oauth2/authorize#")
             Optional("https://api.weibo.com/oauth2/authorize")
             Optional("https://www.baidu.com/?code=4d72ded762a76b07b83d154e14fe575f")   --> 就是这条能得到code
             */
            if let u = urlString2, u.hasPrefix(redirect_uri) {
             //   let code = urlString.components(separatedBy: "code=").last!
            //    print(code)
                
                
                
                
                
                // 获取整个链接的参数 (打印结果: "code=e6188852b1bd5a5b14d193e0343eb69a")
                let query = navigationAction.request.url?.query
                if let q = query {
                    // 截取value 也就是获取code
                    let code = String(q["code=".endIndex...])
                    print("获取到的code: \(code)")
                    // 拿到code 立即去获取access_token
              /*      HOAuthViewModel.shared.getUserAccount(code: code) { (isSccuess) in
                        
                        if isSccuess {
                            print("登录成功")
                            // 移除webView
                            self.dismiss(animated: false) {
                                // 发送通知 -> 切换根控制器
                                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: CHANGEVC), object: nil)
                            }
                        }else{
                            print("登录失败")
                        }
                    }*/
                    
                    // 已经拿到code了. 就不需要webView继续向下进行操作了
                    decisionHandler(.cancel, preferences)
                    return
                }
            }
            decisionHandler(.allow, preferences)
 */
        }
    
    
}
extension OAuthViewController {
    private func loadAccessToken(code : String) {
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

// MARK: 去掉WKWebView自带的 工具栏
fileprivate final class InputAccessoryHackHelper: NSObject {
    @objc var inputAccessoryView: AnyObject? { return nil }
}

extension WKWebView {
    func hack_removeInputAccessory() {
        guard let target = scrollView.subviews.first(where: {
            String(describing: type(of: $0)).hasPrefix("WKContent")
        }), let superclass = target.superclass else {
            return
        }
        
        let noInputAccessoryViewClassName = "\(superclass)_NoInputAccessoryView"
        var newClass: AnyClass? = NSClassFromString(noInputAccessoryViewClassName)
        
        if newClass == nil, let targetClass = object_getClass(target), let classNameCString = noInputAccessoryViewClassName.cString(using: .ascii) {
            newClass = objc_allocateClassPair(targetClass, classNameCString, 0)
            
            if let newClass = newClass {
                objc_registerClassPair(newClass)
            }
        }
        
        guard let noInputAccessoryClass = newClass, let originalMethod = class_getInstanceMethod(InputAccessoryHackHelper.self, #selector(getter: InputAccessoryHackHelper.inputAccessoryView)) else {
            return
        }
        class_addMethod(noInputAccessoryClass.self, #selector(getter: InputAccessoryHackHelper.inputAccessoryView), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        object_setClass(target, noInputAccessoryClass)
    }
}


