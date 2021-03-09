//
//  EmotionViewController.swift
//  nettool
//
//  Created by macliu on 2021/1/21.
//

import UIKit


private let EmotionCell = "EmotionCell"

class EmotionViewController: UIViewController {
    //
    var emotionCallBack : (( _ emotion : Emotion) -> ())?
    // MARK: - 变量
    private lazy var collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: EmotionCollectionViewlayout())
    private lazy var toolBar : UIToolbar = UIToolbar()
    private lazy var manager : EmotionManager = EmotionManager()
    // MARK: - 构造
    init( emotionCallBack : @escaping ( _ emotion : Emotion) -> ()) {
        self.emotionCallBack = emotionCallBack
        
        super.init(nibName: nil, bundle: nil)
        
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: - 函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    
    
}
// MARK: - UI
extension EmotionViewController {
    private func setupUI() {
        //1 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        collectionView.backgroundColor = UIColor.red
        toolBar.backgroundColor = UIColor.darkGray
        //2 设置frame
        //VFL
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["toolBar" : toolBar,"collectionView" : collectionView ]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        
        view.addConstraints(cons)
        //2.准备collectionview
        prepareForCollectionView()
        //toolbar
        prepareForToolBar()
  
    }
    private func prepareForCollectionView() {
        //1 注册cell
        collectionView.register(EmotionCollectionViewCell.self, forCellWithReuseIdentifier: EmotionCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        //2.设置布局
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
    }
    private func prepareForToolBar() {
        //1
        let titles = ["最近","默认","emoji","浪小花"]
        //2.遍历标题，创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: "itemClickItem:")
            item.tag = index
            index += 1
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
            
        }
        tempItems.removeLast()
        
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
        
    }
    @objc private func itemClickItem(item : UIBarButtonItem) {
        //1. 获取点击tag
        let tag = item.tag
        //2.获取组
        let indexPath = NSIndexPath(item: 0, section: tag)
        //3. 滚动到对应位置
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: true)
        
    }
}
// MARK: - 代理
extension EmotionViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emotions.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionCell, for: indexPath) as! EmotionCollectionViewCell
        
        
        //
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.green : UIColor.blue
        //
        let package = manager.packages[indexPath.section]
        let emotion = package.emotions[indexPath.item]
       // print(emotion)
        cell.emotion = emotion
        
        return cell
        
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //取出点击的表情
        let package = manager.packages[indexPath.section]
        let emotion = package.emotions[indexPath.item]
        //2. 插入到最近分组
        insertRecentEmotion(emotion: emotion)
    }
    private func insertRecentEmotion(emotion : Emotion) {
        //把空白或删除的提出
        if emotion.isRemove || emotion.isEmpty {
            return
        }
        //删除一个
        if manager.packages.first!.emotions.contains(emotion) {
            //原来有的
            let index = (manager.packages.first?.emotions.index(of: emotion))!
            
            manager.packages.first?.emotions.remove(at: index)
        }else {
            //没有这个表情
            manager.packages.first?.emotions.remove(at: 19)
        }
        
        
        //2 插入到最近分组
        manager.packages.first?.emotions.insert(emotion, at: 0)
        
        //3
        emotionCallBack!(emotion)
        
    }
}
class EmotionCollectionViewlayout: UICollectionViewFlowLayout {
    override func prepare() {
        //
        super.prepare()
        //1.计算宽度高度
        let itemWH = UIScreen.main.bounds.width / 7
        //设置属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        //属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        //内边距
        let insertMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insertMargin, left: 0, bottom: insertMargin, right: 0)
        
    }
}
