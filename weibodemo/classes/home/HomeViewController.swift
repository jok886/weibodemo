//
//  HomeViewController.swift
//  weibodemo
//
//  Created by macliu on 2021/1/15.
//  15


import UIKit
import SDWebImage
import MJRefresh


class HomeViewController: BaseViewController {
    var isPresented : Bool = false
    
    //在闭包中调用属性 必须加self
    //1.如果出现歧义 2 闭包中使用当前对象的属性和方法
    //
    private lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) -> () in
        self?.titleBtn.isSelected = presented
    }
    // MARK: - lazy
    private lazy var titleBtn : TtitleButton = TtitleButton()

    private lazy var viewModes : [StatusViewMode] = [StatusViewMode]()
    private lazy var tipLabel : UILabel = UILabel()
    private lazy var photoBrowseAnimator : PhotoBrowseDelegate = PhotoBrowseDelegate()
    // MARK: - 系统
    override func viewDidLoad() {
        super.viewDidLoad()

        //
       // VisitorView.addRotationAnim()
        if !isLogin {
            visitorView.addRotation()
            return
        }
        //2
        setupNavitionBar()
        //3
      //  loadStatuses()
        
        //4 设置高度
        //tableView.rowHeight = 
        tableView.estimatedRowHeight = 200
        
        //5下拉刷新
      //  refreshControl = UIRefreshControl()
      //  let demoView = UIView(frame: CGRect(x: 100, y: 0, width: 175, height: 60))
      //  refreshControl?.addSubview(demoView)
        //header
        setupHeaderView()
        
        setupFooterView()
        //设置tip
        setTipLabel()
        //
        setupNotification()
    }



}

// MARK: - 设置UI
extension HomeViewController {
    
    private func setupNavitionBar() {
        //1
       /* let leftBtn = UIButton()
        leftBtn.setImage(UIImage(named: "navigationbar_friendattention"), for: .normal)
        leftBtn.setImage(UIImage(named: "navigationbar_friendattention_highlighted"), for: .highlighted)
        leftBtn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)*/
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        
        
        //2
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        //3 titleview
       // titleBtn.setImage(UIImage(named: "navigationbar_arrow_up"), for: .normal)
       // titleBtn.setImage(UIImage(named: "navigationbar_arrow_down"), for: .selected)
        titleBtn.setTitle("codemyjok886", for: .normal)
        titleBtn.addTarget(self, action:
                            #selector(self.titleBtnClick(myBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
        
        
        
    }
    private func setupHeaderView() {
        //创建header
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "loadNewData")
        //设置属性
        header.setTitle("下拉刷新", for: .idle)
        header.setTitle("释放刷新", for: .pulling)
        header.setTitle("加载中", for: .refreshing)
        
        //
        tableView.mj_header = header
        
        //
        tableView.mj_header?.beginRefreshing()
    }
    private func setupFooterView() {
        tableView.mj_footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: "loadMoreData")
    }
    private func setTipLabel() {
        //添加到父控件
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        
        //
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width, height: 32)
        
        //
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = NSTextAlignment.center
        tipLabel.isHidden = true
        
    }
    private func setupNotification(){
        NotificationCenter.default.addObserver(self, selector: "showPhotoBrowse:", name: NSNotification.Name(rawValue: showPhotoBrowserNotificationhome), object: nil)
    }
    
}
// MARK: - 设置事件

extension HomeViewController {
    @objc private func titleBtnClick(myBtn : TtitleButton) {
        print("titclick")
        //1
    //    myBtn.isSelected = !myBtn.isSelected
        
        //2 创建控制器
        let popupvc = PopupViewController()
      //  vc.view.backgroundColor = UIColor.red
        //设置样式,下面还在不被移除
        popupvc.modalPresentationStyle = .custom
        
        //动画 设置转场代理
        popupvc.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame =  CGRect(x: 100, y: 80, width: 180, height: 250)
        
        present(popupvc, animated: true, completion: nil)
   
    }
    //弹出照片浏览
    @objc private func showPhotoBrowse(note : Notification) {
       // note.userInfo
        //0.
        let indexPath = note.userInfo![showPhotoBrowserNotificationIndexPath] as! IndexPath
        let picURLs   = note.userInfo![showPhotoBrowserNotificationURLs] as! [NSURL]
        let object    = note.object as! PicCollectionView
        
        //1.创建控制器
        let vc = PhotoBrowseViewController(indexPath: indexPath, picURLs: picURLs)
        
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = photoBrowseAnimator
        //
        photoBrowseAnimator.presentedDelgate = object
        photoBrowseAnimator.indexpath = indexPath as NSIndexPath
        photoBrowseAnimator.dismissDelgate = vc
        //2.
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - 请求数据
extension HomeViewController {
    //加载最新数据
    @objc private func loadNewData() {
       // print("shuxin")
        loadStatuses(isNewData : true)
    }
    @objc private func loadMoreData() {
        loadStatuses(isNewData: false)
    }
    
    
    private func loadStatuses(isNewData : Bool) {
        //取出最大ID
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = viewModes.first?.status?.mid ?? 0
        }else{
            max_id = viewModes.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : (max_id - 1)
        }
        
        NetWorkTool.shareIntance.loadStatuses(sinceid: since_id,max_id: max_id) {(result, error) in
            //1. 错误效验
            if error != nil {
                print(error)
                return
            }
            //
            guard let resultArray = result else {
                return
            }
            //遍历字典数据
            var tempViewModel = [StatusViewMode]()
            for staticDict in resultArray {
               let status = Status(dict: staticDict)
               let viewmode = StatusViewMode(status: status)
                tempViewModel.append(viewmode)
                
            }
            //4.将数组模型放入到成员变量的数组中
            if isNewData {
                self.viewModes = tempViewModel + self.viewModes
            }else {
                self.viewModes += tempViewModel
            }
            
            
            
            //缓存图片
            self.cacheImage(viewModels: tempViewModel)
            
            
            
 
        }
    }
    private func cacheImage(viewModels : [StatusViewMode]) {
        //0.
        let group = DispatchGroup.init()
        
        
        //缓存图片
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                group.enter()
                SDWebImageManager.shared.loadImage(with: picURL as URL, options: SDWebImageOptions.highPriority, progress: {(receivedSize:Int,expectedSize:Int,targetURL:URL?)->Void in
                  //  let pro = Float(receivedSize)/Float(expectedSize)*100
                  //  print("进度..\(pro)%")
              }, completed: { ( image:UIImage?,data:Data?, error:Error? ,cacheType:SDImageCacheType, finished:Bool,url:URL?) -> Void in
                 print("下载了一张图片")
        
                group.leave()
             })
            }
        }
        group.notify(queue: DispatchQueue.main) {
            
            
            
            //刷新数据
            self.tableView.reloadData()
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
           // print("刷新表格")
            
            //提示tiplabel
            self.showTipLabel(count: viewModels.count)
            
        }
    }
    //提示tip
    private func showTipLabel(count : Int) {
        //
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新数据" : "\(count)条微博"
        //执行动画
        UIView.animate(withDuration: 1.0) {
            //
            self.tipLabel.frame.origin.y = 44
        } completion: { (_) in
            UIView.animateKeyframes(withDuration: 1.0, delay: 1.5, options: []) {
                self.tipLabel.frame.origin.y = 10;
            } completion: { (_) in
                self.tipLabel.isHidden = true
            }

        }

    }
}
// MARK: - 显示数据
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCellID") as! HomeViewCell
        
        let viewmode = viewModes[indexPath.row]
        cell.viewModel = viewmode
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = viewModes[indexPath.row]
        return viewModel.cellHeight
    }
}
