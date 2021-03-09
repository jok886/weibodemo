//
//  ComposeViewController.swift
//  weibodemo
//
//  Created by macliu on 2021/1/21.
//

/*
     正则表达式
     [a-z]
     [0-9] \\d
     "abc"
     
     ^[a-z]  首字母
     ^[a-z]\\d{2}
     \\d{2,10}  2-10个数字
     
     [a-z]$  ,以字母结尾
     ^[^0-9]  首字母不能0-9
     ^[1-9]\\d{4,11}$  --- 5-12位数字
     ^1[35789]\\d{9}$
 @.*?:    @sdffsdfdssd:
 #.*?#     #dfgrfdgfdg---# 话题
 \\[.*?\\]  表情 [消化]
 
     */



import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    // MARK: -属性
    private lazy var images : [UIImage] = [UIImage]()
    private lazy var emotionVc : EmotionViewController = EmotionViewController {[weak self] (emotion) in
        self?.composeTextView.insertEmotion(emotion: emotion)
        self?.textViewDidChange(self!.composeTextView)
    }
    
    private lazy var titleView : ComposeTitleView = ComposeTitleView()
    
    @IBOutlet weak var picCollectionView: PicPickerCollectionView!
    @IBOutlet weak var composeTextView: ComposeTextView!
    @IBOutlet weak var ToolBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var PicViewtoBottomCons: NSLayoutConstraint! //底部
   
    @IBOutlet weak var picViewHeightCons: NSLayoutConstraint!
    
    //点击照片
    @IBAction func SelPicClick(_ sender: Any) {
        //
        composeTextView.resignFirstResponder()
        //
        picViewHeightCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        //
        
        
    }
    //点击表情
    @IBAction func emojiItemClick(_ sender: Any) {
        //1.退出键盘
        composeTextView.resignFirstResponder()
        //2.切换键盘
        composeTextView.inputView =  composeTextView.inputView != nil ? nil : emotionVc.view
        //3.弹出键盘
        composeTextView.becomeFirstResponder()
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        setupNavgationBar()
        //
        setupNotification()
      
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        composeTextView.becomeFirstResponder()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Navigation



}
// MARK: - UI
extension ComposeViewController {
    private func setupNavgationBar() {
        //1.设置左边的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: "closeItemClick")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .plain, target: self, action: "sendItemClick")
        navigationItem.rightBarButtonItem?.isEnabled = false
        //设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    private func setupNotification() {
        //监听通知
        NotificationCenter.default.addObserver(self, selector: "keyboardWillChangeFrameNotification:", name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: "selPicClick", name: NSNotification.Name(rawValue: showPhotoBrowserNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: "removePicClick:", name: NSNotification.Name(rawValue: removePhotoBrowserNotification), object: nil)
        
    }
}
// MARK: - 事件
extension ComposeViewController {
    
  
    //关闭
    @objc private func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    //发送微博
    @objc private func sendItemClick() {
        //0.
        composeTextView.resignFirstResponder()
  
      // 1.获取微博正文
        let statusext = composeTextView.getEmotionString()
        
        //闭包
        let finishCallback = { (isSuccess : Bool) in
            if !isSuccess {
                SVProgressHUD .showError(withStatus: "发送失败")
                return
            }
            SVProgressHUD .showSuccess(withStatus: "发送成功")
            self.dismiss(animated: true, completion: nil)
        }
        //2获取微博图片
        if let image = images.first {
            NetWorkTool.shareIntance.sendStatus(statusText: statusext, image: image ,isSuccess: finishCallback)
        }else {
            //3.
            NetWorkTool.shareIntance.sendStatus(statusText: statusext,isSuccess: finishCallback)
               
        }
  
    }
    //监听键盘事件
    @objc private func keyboardWillChangeFrameNotification(note : NSNotification ) {
        //1.
        let duration = note.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        //
        let endFrame = (note.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        //2.
        let margin = UIScreen.main.bounds.height - y
        //执行动画
        ToolBottomCons.constant = margin
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
}

// MARK: - 照片添加和删除
extension ComposeViewController {
    @objc private func selPicClick() {
        
        //弹出照片选择器
        //1 判断照片源可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        //2 创建
        let pic = UIImagePickerController()
        //设置照片源
        pic.sourceType = .photoLibrary
        //代理
        pic.delegate = self
        
        //弹出
        present(pic, animated: true, completion: nil)
        
    }
    @objc private func  removePicClick(note : Notification) {
        //删除照片
        guard let image = note.object as? UIImage else{
            return
        }
        
        guard let index = images.index(of: image) else {
            return
        }
        //删除数组中的照片
        images.remove(at: index)
        //重新赋值
        picCollectionView.images = images
    }
}



// MARK: - 代理
extension ComposeViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //1.获取选中照片
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //2.展示照片 添加数组中
        images.append(image)
        //将数组给collectionview
        picCollectionView.images = images
        
        //
        picker.dismiss(animated: true, completion: nil)
    }
}
extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.composeTextView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        composeTextView.resignFirstResponder()
    }
}
