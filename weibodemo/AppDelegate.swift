//
//  AppDelegate.swift
//  weibodemo
//
//  Created by macliu on 2021/1/15.
//

/*
git add .
git commit -m "事件"
git push
*/




import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var defaualtViewController : UIViewController? {
        let isLogin = UserAccountViewMode.shareInstance.isLogin
        return isLogin ? WelcomeViewController() : UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //全局颜色
        UITabBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().tintColor = UIColor.orange
        
        //创建window
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = defaualtViewController
        window?.makeKeyAndVisible()
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

/*    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }*/


}


func MGLog<T>(message : T,file : String = #file,funcName : String = #function,lineNum : Int = #line){
    /// 全局打印函数， 任何地方都可以访问
    /// 第二个参数开始，默认值
    #if DEBUG
       let fileName = (file as NSString).lastPathComponent
       print("\(fileName):[\(lineNum)] - \(message)")
    
    #endif
    
}
