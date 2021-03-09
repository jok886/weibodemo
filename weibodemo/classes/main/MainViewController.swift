//
//  MainViewController.swift
//  weibodemo
//
//  Created by macliu on 2021/1/15.
//

import UIKit

class MainViewController: UITabBarController {

    //MARK-- lazy
    private lazy var imageNames = ["tabbar_home","tabbar_message_center","","tabbar_discover","tabbar_profile"]
    
   // private lazy var composeBtn : UIButton = UIButton.createButton(imageName: "tabbar_compose_icon_add", bgimageName: "tabbar_compose_button")
    private lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgimageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComposeBtn()
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTabbarItems()
    }
    
    func loadtab() {
        //1 json
    /*    guard  let jsonPath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
            return
        }
        //读取json
        guard let jsonData = NSData(contentsOfFile: jsonPath) else {
            return
        }
        //zhuan shuzu
        //throws 抛出异常 处理
        
        /*
         1.try 手动捕获
         do {
             try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers)
             
         } catch  {
             print(error) //异常信息
         }
         
         2.try? 常用方式 --系统处理异常，返回空 nil 或 返回object
         3.try! 直接告诉系统没有异常，如果有异常 程序崩溃
         
 
 
       */
        
        
        
        
        guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) else {
            return
        }
        
        guard let dictArray =  anyObject as? [[String : AnyObject]] else {
            return
        }
        //
        for dict in dictArray {
            print(dict)
            //1
            guard let vcName = dict["vcName"] as? String else{
                continue
            }
            //2
            guard let vcTitle = dict["title"] as? String else{
                continue
            }
            //3
            guard let vcimageName = dict["imageName"] as? String else{
                continue
            }
            addChild(vcName, title: vcTitle, imageName: vcimageName)
        }
       

    //   print(HomeViewController())
        
        //tabBar.tintColor = UIColor.orange
        // Do any additional setup after loading the view.
      /*  addChild("HomeViewController", title: "首页", imageName: "tabbar_home")
        addChild("MessageViewController", title: "消息", imageName: "tabbar_message_center")
        addChild("DiscoverViewController", title: "发现", imageName: "tabbar_discover")
        addChild("ProfileViewController", title: "我", imageName: "tabbar_profile")
        */
        */
        
    }
    //swift 支持重载
    //方法重载 ，名称相同，参数不一样，（类型或个数）
    //private 当前文件可访问，其他不能访问
    private func addChild(_ childName: String,title : String,imageName : String) {
        //1.创建控制为
       // let childvc = HomeViewController()
       // childVc.view.backgroundColor = UIColor.yellow
        //  获取命名空间
        guard let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String  else{
            return
        }
        
        
        guard let childVcClass = NSClassFromString(namespace + "." + childName) else{
            print("没有获取到class error")
            return
        }
        guard let childVcType =  childVcClass as? UIViewController.Type else {
            
            return
        }
        
        let childVc = childVcType.init()
        //2设置标题
        childVc.title = title
        childVc.tabBarItem.image = UIImage(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        //3导航控制器
        let childnav = UINavigationController(rootViewController: childVc)
        //4添加
        addChild(childnav)
        
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
//mark:--设置UI
extension MainViewController {
    private func setupComposeBtn() {
        //1
        tabBar.addSubview(composeBtn)
        
      /*  composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: .highlighted)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        //
        composeBtn.sizeToFit()*/
        //
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        //监听事件
        //1.Selector("composeBtnClick")   2."composeBtnClick"
        composeBtn.addTarget(self, action: #selector(self.composeBtnClick), for: .touchUpInside)
        
    }
    private func setupTabbarItems() {
        //1.遍历所有item
        for i in 0..<tabBar.items!.count {
            //获取
            let item = tabBar.items![i]
            //如果是2 不能交互
            if i == 2 {
                item.isEnabled = false
                continue
            }
            
            //设置其他的选中图片
            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
        }
    }
}
// MARK:--事件
extension MainViewController {
    //事件监听 发送消息，
    //讲方法包装@SEL ，-》方法列表-》imp指针（函数指针）
    //swift 函数声明为private 不会添加到函数方法列表中
    //@objc private,该方法依然加到方法列表
    @objc private func composeBtnClick() {
       // print("composeBtnClick")
        //创建发布控制器
        let composeVC = ComposeViewController()
        //包装导航控制器
        let composeNav = UINavigationController(rootViewController: composeVC)
        composeNav.modalPresentationStyle = .fullScreen
        //
        present(composeNav, animated: true, completion: nil)
        
    }
    
}
