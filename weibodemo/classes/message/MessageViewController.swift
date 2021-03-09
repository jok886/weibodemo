//
//  MessageViewController.swift
//  weibodemo
//
//  Created by macliu on 2021/1/15.
//

import UIKit

class MessageViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        visitorView.setupVisitorViewInfo(iconName: "visitordiscover_image_message", tipString: "登录后，别人评论你的微博，给你发消息，都会在在这里收到通知")
  
    }

    // MARK: - Table view data source

}
//MARK:- 表格
extension MessageViewController {
    /// 设置UI相关
    func setupUI() {
        
        // 登录后，显示自定义view
        guard isLogin else {
            return
        }
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK:- 表格数据源、代理方法
extension MessageViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = "测试数据 --- \(indexPath.row)"
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 29
    }
    
    
    //MARK:- 代理方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // MGLog("点击了 --- \(indexPath.row)")
    }
}

